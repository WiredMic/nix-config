{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
  ];

  # KDE
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
}
