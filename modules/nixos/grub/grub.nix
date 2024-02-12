{
  pkgs,
  ...
}:
{
  imports = [
  
  ];
  boot.loader = {
     efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      entryOptions = {

      }
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
        menuentry "uefi-firmware" {
          fwsetup
        }
      '';
    };
    grub2-theme = {
      enable = true;
      theme = "stylish";
      icon = "color";
      screen = "1080p";
      footer = true;
    };
  };
}
