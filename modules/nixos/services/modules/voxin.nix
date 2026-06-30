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
      # TODO use mkPackageOption if Voxin is packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.voxin or null;
        defaultText = "pkgs.voxin";
        description = ''
          The Voxin text-to-spech package to use.

          Since `voxin` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.voxin";
      };
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
