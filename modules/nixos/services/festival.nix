{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.festival;
  progCfg = config.programs.festival;
in
{
  options.services.festival = {
    enable = lib.mkEnableOption "the Festival TTS server";

    package = mkOption {
      type = types.package;
      default =
        if progCfg.enable then
          progCfg.finalPackage
        else
          pkgs.festival.withVoices (
            voices: with voices; [
              kal_diphone
            ]
          );
      defaultText = lib.literalExpression ''
        if config.programs.festival.enable then config.programs.festival.finalPackage
        else pkgs.festival.withVoices (voices: with voices; [ kal_diphone ])
      '';
    };

    port = mkOption {
      type = types.port;
      default = 1314;
      description = ''
        Port for the Festival server to listen on.
        Sets the `server_port` Scheme variable in `siteinit.scm`.
      '';
    };

    extraSiteInit = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra Scheme expressions appended to `siteinit.scm` for the server
        package. Evaluated after the port setting.
        Useful for access control variables such as `server_access_list`,
        `server_deny_list`, and `server_passwd`.
      '';
    };

    heap = mkOption {
      type = types.nullOr (types.ints.between 0 67108863);
      default = null;
      example = 1000000;
      description = ''
        Scheme heap size in Lisp cells (`festival --heap`). Bounded at
        67108863 -- past this, `heap * 32` overflows a signed 32-bit int
        inside Festival's WALLOC and `malloc` is called with a negative
        size, crashing the server outright rather than failing to allocate
        gracefully.
      '';
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = ''
        The Festival package used by the server, with port and server
        site-init baked in.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.festival.finalPackage =
      let
        serverSiteInit =
          lib.optionalString (cfg.port != 1314) "(set! server_port ${toString cfg.port})\n"
          + cfg.extraSiteInit;
      in
      if serverSiteInit == "" then
        cfg.package
      else
        let
          oldFestlibdir = "export FESTLIBDIR=\${FESTLIBDIR-'${cfg.package}/lib'}";
          newFestlibdir = "export FESTLIBDIR=\${FESTLIBDIR-'${lib.placeholder "out"}/lib'}";
        in
        pkgs.symlinkJoin {
          name = "festival-server";
          paths = [ cfg.package ];
          meta.mainProgram = "festival";
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            source ${pkgs.makeWrapper}/nix-support/setup-hook
            cp --remove-destination $(realpath $out/lib/siteinit.scm) $out/lib/siteinit.scm
            chmod u+w $out/lib/siteinit.scm
            substituteInPlace $out/lib/siteinit.scm \
              --replace-fail "(provide 'siteinit)" ""
            cat >> $out/lib/siteinit.scm << 'EOF'
            ${serverSiteInit}
            (provide 'siteinit)
            EOF
            for bin in $out/bin/*; do
              if [[ "$(basename "$bin")" != *"-wrapped" ]]; then
                cp --remove-destination $(realpath "$bin") "$bin"
                chmod u+w "$bin"
                substituteInPlace "$bin" \
                  --replace-fail \
                    ${pkgs.lib.escapeShellArg oldFestlibdir} \
                    ${pkgs.lib.escapeShellArg newFestlibdir}
              fi
            done
          '';
        };

    systemd.user.services.festival = {
      description = "Festival speech synthesis server";
      wantedBy = [ "default.target" ];
      restartTriggers = [ cfg.finalPackage ];
      serviceConfig = {
        ExecStart =
          "${lib.getExe cfg.finalPackage} --server"
          + lib.optionalString (cfg.heap != null) " --heap ${toString cfg.heap}";
        Restart = "on-failure";
      };
    };
  };
}
