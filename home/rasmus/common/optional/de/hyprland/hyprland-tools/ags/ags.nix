{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];
  options = {
    hyprland.ags.enable = lib.mkEnableOption "enables my ags config";
  };

  config = lib.mkIf config.hyprland.ags.enable {
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ./ags-config-dir;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [ gtksourceview webkitgtk accountsservice ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          # bar
          "ags -c ${config.xdg.configHome}/ags/simple-bar/config.js -b bar &"
          # app launcher
          "ags -c ${config.xdg.configHome}/ags/applauncher/config.js -b app &"
          # # Notification daemon
          # "ags -c ${config.xdg.configHome}/ags/notification-popups/config.js &"
        ];

        bind = [
          "$mainMod, SPACE, exec, ags -b app -t applauncher" # Show the graphicall app launcher
        ];
      };
    };
  };
}
