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

  # Baratinoo is not packaged in Nixpkgs
  visible = false;
  displayName = "Baratinoo";
  binary = "sd_baratinoo";
  confFiles = [
    "baratinoo.conf"
  ];

}
