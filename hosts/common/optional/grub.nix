{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = {
    my.grub.efi.enable = lib.mkEnableOption "enables my grub config";
  };

  config = lib.mkIf config.my.grub.efi.enable {
    boot.loader = {
      efi = { canTouchEfiVariables = true; };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
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
      # grub2-theme = {
      #   enable = true;
      #   theme =  lib.mkDefault "stylish";
      #   icon = "color";
      #   screen = "1080p";
      #   footer = true;
      # };
    };
  };

}
