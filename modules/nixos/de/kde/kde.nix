{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../programs/sddm/sddm.nix
  ];

  # KDE
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
}
