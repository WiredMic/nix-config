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
      enable = mkEnableOption "Flite text-to-speech output module.";
      package = mkPackageOption pkgs "flite" { };
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

  displayName = "Flite";
  binary = "sd_flite";
  confFiles = [
    "flite.conf"
  ];
}
