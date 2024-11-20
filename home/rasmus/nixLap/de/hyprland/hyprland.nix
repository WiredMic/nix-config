{ pkgs, config, lib, userSettings, inputs, ... }: {
  imports = [
    # inputs.split-monitor-workspaces.homeManagerModules.default
  ];

  options = {
    my.hyprland.enable = lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.hyprland.enable {
    home.packages = with pkgs; [ wev ];

    wayland.windowManager.hyprland = {
      # https://github.com/hyprland-community/awesome-hyprland
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      settings = {

        exec-once = [ "${./check-battery.sh}" ];
        monitor = [
          # Setup monitors
          # See https://wiki.hyprland.org/Configuring/Monitors/
          "desc:LG Display 0x05CF,1920x1080@144,0x0,1"
          ", preferred, auto, 1"
        ];

        #   exec-once = [
        #     # ~/.config/hypr/xdg-portal-hyprland
        #     # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #     "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #   ];

        input = {
          touchpad = { natural_scroll = "yes"; };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "on";
          workspace_swipe_fingers = "4";
          workspace_swipe_distance = "200";
          workspace_swipe_cancel_ratio = "0.25";
        };

        bind = [
          #     # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          #     "$mainMod, L, exec, swaylock" # Lock the screen
          #     "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)

        ];

      };

      # extraConfig = ''
      #   #  _   _                  _                 _
      #   # | | | |_   _ _ __  _ __| | __ _ _ __   __| |
      #   # | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
      #   # |  _  | |_| | |_) | |  | | (_| | | | | (_| |
      #   # |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
      #   #        |___/|_|
      #   # modified by: Rasmus Enevolden (2023)
      #   # -----------------------------------------------------------------

      #   # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      #   # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

      #   # rules below would make the specific app transparent
      #   # windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
      #   # windowrulev2 = opacity 0.8 0.8,class:^(thunar)$
      #   # windowrulev2 = opacity 0.8 0.8,class:^(chromium)$
      #   # windowrulev2 = opacity 0.8 0.8,class:^(Code)$

      #   # bind = $mainMod SHIFT, W, exec, $HOME/.dotfiles/scripts/wallpaper-swaybg.sh
      #   # bind = $mainMod SHIFT, B, exec, $HOME/.dotfiles/waybar/launch.sh

      #   # Scroll through existing workspaces with mainMod + scroll
      #   bind = $mainMod, mouse_down, workspace, e+1
      #   bind = $mainMod, mouse_up, workspace, e-1

      #   # Move/resize windows with mainMod + LMB/RMB and dragging
      #   bindm = $mainMod, mouse:272, movewindow
      #   bindm = $mainMod, mouse:273, resizewindow
      # '';
    };
  };

}
