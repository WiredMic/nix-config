{
  lib,
  config,
  pkgs,
  userSettings,
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

    # boot manager
    ./boot.nix

    # Dislexia help
    ./tts.nix

    # gaming
    ./gaming/games.nix
    ./gaming/emulation.nix

    # cloud storage
    ./cloud/onedrive.nix
    ./cloud/syncthing.nix
    ./vpn.nix

    # ricing
    ./stylix/stylix.nix

    ./distrobox.nix

    # server
    ./server/server.nix

    # Programming
    ./arduino.nix
    ./llm.nix

    # wifi certs
    ./aau-wifi-cert/aau-wifi-cert.nix

    ./kanata.nix

    ./file_browser/thunar.nix
  ];

  # Because this is the optional dir not everything needs to be enabled by default
  de.cosmic.enable = lib.mkDefault userSettings.de.cosmic;
  de.gnome.enable = lib.mkDefault userSettings.de.gnome;
  de.kde.enable = lib.mkDefault userSettings.de.kde;
  de.hyprland.enable = lib.mkDefault userSettings.de.hyprland;

  my.sddm.enable =
    if (config.de.kde.enable || config.de.hyprland.enable) then
      lib.mkForce true
    else
      lib.mkDefault false;

  my.boot.efi.enable = lib.mkDefault false;

  my.tts.enable = lib.mkDefault false;

  my.games.enable = lib.mkDefault false;
  my.emulation.enable = lib.mkDefault false;

  stylix.image = lib.mkDefault ./stylix/hong-kong-night.jpg;
  my.stylix.enable =
    if (config.de.kde.enable || config.de.hyprland.enable) then
      lib.mkForce true
    else
      lib.mkDefault false;

  my.distrobox.enable = lib.mkDefault false;

  my.arduino.enable = lib.mkDefault false;
  my.ollama.enable = lib.mkDefault false;

  my.aau-wifi-cert.enable = lib.mkDefault false;

  # Clouds
  my.onedrive.enable = lib.mkDefault false;
  my.syncthing.enable = lib.mkDefault false;
  my.vpn.enable = lib.mkDefault false;

  my.kanata.enable = lib.mkDefault userSettings.de.hyprland;

  my.thunar.enable = lib.mkDefault false;
}
