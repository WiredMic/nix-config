{
  lib,
  pkgs,
  mkPackageOption,
  mkEnableOption,
  mkOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Openjtalk text-to-speech output module.";
      # TODO use mkPackageOption when Open JTalk is packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.openjtalk or null; # safe even if attr doesn't exist
        defaultText = "pkgs.openjtalk";
        description = ''
          The Open JTalk package to use.

          Since `openjtalk` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.openjtalk";
      };
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  displayName = "Open JTalk";
  binary = "sd_openjtalk";
  confFile = "openjtalk.conf";

  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/openjtalk.conf".text =
        (builtins.readFile "${pkgs.speechd}/etc/speech-dispatcher/modules/${modCfg.confFile}")
        + "\n"
        + modCfg.extraConfig;
    };
}
