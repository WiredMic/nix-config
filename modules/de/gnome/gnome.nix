{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../programs/sddm/sddm.nix
  ];

  services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

 

}
