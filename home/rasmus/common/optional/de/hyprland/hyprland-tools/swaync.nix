{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.swaync.enable =
      lib.mkEnableOption "enables swaync for notifications in hyprland";
  };

  config = lib.mkIf config.hyprland.swaync.enable {
    home.packages = with pkgs;
      [
        # notification daemon
        libnotify.out
      ];

    # Notification daemon
    services.swaync = {
      enable = true;
      package = pkgs.swaynotificationcenter;
      # settings
      # style
    };
  };
}
