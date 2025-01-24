{ pkgs, lib, config, userSettings, ... }: {
  imports = [
    # de 
    ./hyprland/hyprland.nix

  ];

  my.hyprland.enable = lib.mkForce userSettings.de.hyprland;
  # my.hyprland.enable = lib.mkForce false;
}
