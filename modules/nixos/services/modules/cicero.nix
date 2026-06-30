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
      enable = mkEnableOption "Cicero text-to-speech output module.";
      # TODO use mkPackageOption if Cicero gets packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.cicero or null;
        defaultText = "pkgs.cicero";
        description = ''
          The Cicero text-to-spech package to use.

          Since `cicero` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.cicero";
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

  # TODO Delete if Cicero gets packaged in Nixpkgs
  visible = false;
  displayName = "Cicero";
  binary = "sd_cicero";
  confFiles = [
    "cicero.conf"
  ];

}
