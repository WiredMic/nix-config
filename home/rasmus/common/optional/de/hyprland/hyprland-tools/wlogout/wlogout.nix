{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.wlogout.enable = lib.mkEnableOption "enables wlogout for hyprland";
  };

  config = lib.mkIf config.hyprland.wlogout.enable {
    home.packages = with pkgs; [ wlogout ];

    xdg.configFile."wlogout/layout" = {
      enable = true;
      recursive = true;
      source = ./layout;
    };
  };
}
