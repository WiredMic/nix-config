 {
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Here everything in the optional dir is imported.
    
    # DE
    ./de/cosmic/cosmic.nix
    ./de/gnome/gnome.nix
    ./de/kde/kde.nix
    ./de/hyprland/hyprland.nix
    
    # display manager
    ./sddm/sddm.nix

    ./tts.nix

    # gaming
    ./gaming/games.nix
    ./gaming/emulation.nix

    # cloud storage
    ./onedrive.nix
  ];

  # Because this is the optional dir not everything needs to be enabled by default
  de.cosmic.enable = lib.mkDefault false;
  de.gnome.enable = lib.mkDefault false;
  de.kde.enable = lib.mkDefault false;
  de.hyprland.enable = lib.mkDefault false;

  my.sddm.enable = lib.mkDefault false;

  my.tts.enable = lib.mkDefault false; 

  my.games.enable = lib.mkDefault false;
  my.emulation.enable = lib.mkDefault false;

  my.onedrive.enable = lib.mkDefault false;
}
