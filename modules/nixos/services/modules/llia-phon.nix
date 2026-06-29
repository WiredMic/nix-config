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
      enable = mkEnableOption "Llia Phon text-to-speech output module.";
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

  # Llia Phon is not packaged in Nixpkgs.
  visible = false;
  displayName = "Llia Phon";
  confFiles = [
    "llia_phon-generic.conf"
  ];
}
