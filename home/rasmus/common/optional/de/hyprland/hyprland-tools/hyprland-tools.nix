{ config, lib, pkgs, userSettings, ... }:

{

  imports = [
    ./wlogout/wlogout.nix
    ./ags/ags.nix
    ./swaync.nix
    ./swayosd.nix
    ./hypridle.nix
    ./hyprshot.nix
    ./wofi.nix
    ./waybar/waybar.nix
  ];

  hyprland.wlogout.enable = lib.mkDefault false;

  # bar
  hyprland.ags.enable = lib.mkDefault false;

  # Notification daemon
  hyprland.swaync.enable = lib.mkDefault false;

  # OSD daemon
  hyprland.swayosd.enable = lib.mkDefault false;

  # Idle and Lock
  hyprland.hypridle.enable = lib.mkDefault false;

  # Screenshot
  hyprland.hyprshot.enable = lib.mkDefault false;

  # App launcher
  hyprland.wofi.enable = lib.mkDefault false;

  # Status Bar
  hyprland.waybar.enable = lib.mkDefault false;
}
