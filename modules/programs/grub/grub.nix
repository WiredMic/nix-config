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
      theme = pkgs.nixos-grub2-theme;  
    };
  };
}
