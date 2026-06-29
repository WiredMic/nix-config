{
  lib,
  pkgs,
  mkEnableOption,
  mkOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "eSpeak NG using MBROLA text-to-speech output module.";
      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debug output.
        '';
        example = true;
      };
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  displayName = "eSpeak NG MBROLA";
  binary = "sd_espeak-ng-mbrola";
  confFiles = [
    "espeak-ng-mbrola"
    "espeak-ng-mbrola-generic"
  ];
}
