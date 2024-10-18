{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.waybar.enable =
      lib.mkEnableOption "enables waybar as a status bar for hyprland";
  };

  config = lib.mkIf config.hyprland.waybar.enable {
    # programs.waybar = {
    #   enable = true;
    #   package = pkgs.waybar;
    #   # settings = { };
    #   # style = { };
    #   # systemd.enable = true;
    #   # systemd.target = "";
    # };

    home.packages = with pkgs; [ waybar ];

    wayland.windowManager.hyprland = {
      settings = { exec-once = [ "waybar &" ]; };
    };

    xdg.configFile."waybar" = {
      # enable = true;
      recursive = true;
      source = ./dpgraham4401;
    };
  };
}
