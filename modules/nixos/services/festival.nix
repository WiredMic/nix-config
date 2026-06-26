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
  };

  config = mkIf cfg.enable {
    systemd.user.services.festival = {
      description = "Festival speech synthesis server";
      wantedBy = [ "default.target" ];
      restartTriggers = [ config.programs.festival.finalPackage ];
      serviceConfig = {
        ExecStart =
          "${lib.getExe cfg.package} --server"
          + lib.optionalString (cfg.heap != null) " --heap ${toString cfg.heap}";
        Restart = "on-failure";
      };
    };
  };
}
