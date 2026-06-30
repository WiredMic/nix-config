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
      enable = mkEnableOption "Voxin text-to-speech output module.";
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

  # TODO remove if mkPackageOption if Voxin is packaged
  visiable = false;
  displayName = "Voxin";
  binary = "sd_voxin";
  confFiles = [
    "voxin.conf"
  ];
}
