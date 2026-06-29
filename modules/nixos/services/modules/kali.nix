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
      enable = mkEnableOption "Kali text-to-speech output module.";
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

  # Kali is not packaged in Nixpkgs.
  visible = false;
  displayName = "Kali";
  binary = "sd_kali";
  confFiles = [
    "kali.conf"
  ];
}
