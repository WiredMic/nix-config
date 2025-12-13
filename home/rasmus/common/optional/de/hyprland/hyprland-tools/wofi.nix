{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    hyprland.wofi.enable = lib.mkEnableOption "enables wofi as an app laucher in hyprland";
  };

  config = lib.mkIf config.hyprland.wofi.enable {
    home.packages = with pkgs; [ killall ];

    programs.wofi = {
      enable = true;
      package = pkgs.wofi;
      # settings = { };
      # style = { };
    };

    # stylix.targets.wofi.enable = true;

    wayland.windowManager.hyprland = {
      settings = {

        bind = [
          "$mainMod , SPACE, exec, pkill wofi || wofi --show=drun --allow-images "
        ];
      };
    };

  };
}
