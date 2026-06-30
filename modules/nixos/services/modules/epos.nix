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
      enable = mkEnableOption "Epos text-to-speech output module.";
      # TODO use mkPackageOption if Epos is packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.epos or null;
        defaultText = "pkgs.epos";
        description = ''
          The Epos text-to-spech package to use.

          Since `epos` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.epos";
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

  # TODO remove if Epos is packaged in Nixpkgs
  visible = false;
  displayName = "Epos";
  confFiles = [
    "epos-generic.conf"
  ];

}
