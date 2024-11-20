{ pkgs, config, lib, userSettings, inputs, ... }: {
  imports = [
    # inputs.split-monitor-workspaces.homeManagerModules.default
    ./hyprland-tools/hyprland-tools.nix
  ];

  options = {
    my.common.hyprland.enable = lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.common.hyprland.enable {

    home.packages = with pkgs; [
      wtype # middle mouse tab
      #   wev
      #   swww

      #   kcalc
      #   thunderbird

      #   # file manager
      #   xfce.thunar
      #   # set services.gvfs.enable = true; in NixOS config
      #   # edit `Open Terminal Here` to "xdg-open ."
      #   # xfce.xfconf
      #   samba
      #   smbnetfs
      killall

      #   kdePackages.qt6ct
      #   # (callPackage ./base16-qt5ct.nix { })
      #   adwaita-qt6
      #   kdePackages.qtstyleplugin-kvantum

    ];

    # Personal Hyprland tools
    # logout menu
    hyprland.wlogout.enable = true;

    #  bar, app launcher
    hyprland.ags.enable = false;

    # Bar
    hyprland.waybar.enable = true;

    # App launcher
    hyprland.wofi.enable = true;

    # Notification daemon
    hyprland.swaync.enable = true;

    # OSD daemon
    hyprland.swayosd.enable = true;

    # Idle Daemon and lock
    hyprland.hypridle.enable = true;

    # Screenshot
    hyprland.hyprshot.enable = true;

    #

    wayland.windowManager.hyprland = {
      #   # https://github.com/hyprland-community/awesome-hyprland
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      settings = {
        exec-once = [
          #       # ~/.config/hypr/xdg-portal-hyprland
          #       # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          #       "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          #       # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
          "emacs --daemon"
          "flatpak run com.discordapp.Discord --start-minimized"
        ];

        #     # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        #     # plugins = [
        #     #   inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
        #     # ];

        input = {
          kb_layout = "us, dk";
          # kb_variant =
          # kb_model =
          kb_options = "grp:alt_shift_toggle"; # ,caps:swapescape";
          # kb_rules =

          follow_mouse = 1;

          numlock_by_default = true;
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          "col.active_border" = lib.mkDefault "rgb(cdd6f4)";
          "col.inactive_border" = lib.mkDefault "rgba(595959aa)";

          layout = "dwindle";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = "10";
          # blur = yes
          # blur_size = 7
          # blur_passes = 3
          # blur_new_optimizations = on
          blurls = "lockscreen";

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = lib.mkDefault "rgba(1a1a1aee)";

        };

        misc = { disable_hyprland_logo = "yes"; };

        animations = {
          enabled = "yes";

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        "$mainMod" = "SUPER";

        bind = [
          #       # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mainMod, E, exec, ${userSettings.editor}" # open VISUAL editor
          "$mainMod, Q, exec, kitty" # open the terminal
          "$mainMod SHIFT, X, killactive," # close the active window
          "$mainMod, M, exec, killall wlogout || wlogout --protocol layer-shell" # show the logout window
          #       "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)
          "$mainMod, D, exec, thunar" # Show the graphical file browser
          "$mainMod, F11, fullscreen"

          "$mainMod, V, togglefloating," # Allow a window to float
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle

          "$mainMod, F , exec, firefox"

          # keyboard layout switch
          # ", Alt_L&Alt_R, exec ,hyprctl switchxkblayout at-translated-set-2-keyboard next"

          # Move focus with mainMod + vim keys
          "$mainMod, l, movefocus, l"
          "$mainMod, h, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"

          # Mouse shortcuts
          ", mouse_left, exec, wtype -M ctrl -M shift -P Tab -m ctrl -m shift"
          ", mouse_right, exec, wtype -M ctrl -P Tab -m ctrl"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

        ];

        binde = [ ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrulev2 = [ "opacity 0.8 0.8,class:^(kitty)$" ];

      };

      # extraConfig = ''
      #   #     #  _   _                  _                 _
      #   #     # | | | |_   _ _ __  _ __| | __ _ _ __   __| |
      #   #     # | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
      #   #     # |  _  | |_| | |_) | |  | | (_| | | | | (_| |
      #   #     # |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
      #   #     #        |___/|_|
      #   #     # modified by: Rasmus Enevolden (2023)
      #   #     # -----------------------------------------------------------------

      #   #     # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      #   #     # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

      #   #     # rules below would make the specific app transparent
      #   #     # windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
      #   #     # windowrulev2 = opacity 0.8 0.8,class:^(thunar)$
      #   #     # windowrulev2 = opacity 0.8 0.8,class:^(chromium)$
      #   #     # windowrulev2 = opacity 0.8 0.8,class:^(Code)$

      #   #     # bind = $mainMod SHIFT, W, exec, $HOME/.dotfiles/scripts/wallpaper-swaybg.sh
      #   #     # bind = $mainMod SHIFT, B, exec, $HOME/.dotfiles/waybar/launch.sh

      #   #     # Scroll through existing workspaces with mainMod + scroll
      #   #     bind = $mainMod, mouse_down, workspace, e+1
      #   #     bind = $mainMod, mouse_up, workspace, e-1

      #   #     # Audio shortcuts [works only with spotify]
      #   #     # bind = , code:173, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
      #   #     # bind = , code:172 , exec ,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
      #   #     # bind = , code:171, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

      #   #     # binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      #   #     # binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

      # '';
    };
  };

}