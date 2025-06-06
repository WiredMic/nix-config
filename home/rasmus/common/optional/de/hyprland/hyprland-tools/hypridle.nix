{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.hypridle.enable =
      lib.mkEnableOption "enables hypridle idling in hyprland";
  };

  config = lib.mkIf config.hyprland.hypridle.enable {
    home.packages = with pkgs;
      [
        #   swaylock
      ];

    services.hypridle = {
      enable = true;
      package = pkgs.hypridle;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };

    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [ "hypridle" ];

        bind = [
          "$mainMod SHIFT, L, exec, hyprlock" # lock the session
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        input-field = lib.mkDefault [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>Input Password...</i>";
        }];
      };
    };
  };
}
