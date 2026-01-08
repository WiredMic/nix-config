{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ];

  options = {
    my.boot.efi.enable = lib.mkEnableOption "enables my systemd-boot config";
  };

  config = lib.mkIf config.my.boot.efi.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
      };
    };

    fileSystems."/boot".options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
