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
      enable = mkEnableOption "Pico text-to-speech output module.";
      package = mkPackageOption pkgs "picotts" { };
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

  displayName = "SVOX Pico";
  binary = "sd_pico";
  confFile = "pico.conf";
}
