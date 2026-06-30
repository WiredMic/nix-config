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
      enable = mkEnableOption "Baratinoo text-to-speech output module.";
      # TODO use mkPackageOption if Baratinoo gets packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.baratinoo or null;
        defaultText = "pkgs.baratinoo";
        description = ''
          The Baratinoo / Voxygen TTS package to use.

          Since `baratinoo` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.baratinoo";
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

  # TODO Delete if Baratinoo gets packaged in Nixpkgs
  visible = false;
  displayName = "Baratinoo";
  binary = "sd_baratinoo";
  confFiles = [
    "baratinoo.conf"
  ];

}
