{ pkgs, config, lib, ... }: {
  imports = [ ];

  options = {
    my.hyprland.enable = lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.hyprland.enable {
    home.packages = with pkgs; [
      wtype
      wev
      wl-clipboard-rs
      swww

      # screenshot https://www.youtube.com/watch?v=J1L1qi-5dr0
      grim
      slurp
      swappy
      imagemagick_light

      swaylock
      wlogout
      kcalc
      thunderbird

      # file manager
      xfce.thunar
      # set services.gvfs.enable = true; in NixOS config
      # edit `Open Terminal Here` to "xdg-open ."
      # xfce.xfconf
      samba
      smbnetfs
      kdePackages.dolphin
      killall

    ];

    programs = {
      tofi.enable = true;
      rofi.enable = true;
      kitty.enable = true;
      firefox.enable = true;

      # thunderbird = { # Does not get themed
      #   enable = true;
      #   profiles."Rasmus Enevoldsen" = { isDefault = true; };
      # };
    };

    xdg.configFile."wlogout" = {
      enable = true;
      recursive = true;
      source = ./wlogout;
    };

    wayland.windowManager.hyprland = {
      # https://github.com/hyprland-community/awesome-hyprland
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      settings = {

        # Setup monitors
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          "desc:Samsung Electric Company LC27G5xT H4ZR300911,2560x1440@144,0x0,1"
          "desc:Acer Technologies G236HL LVNEE0052482,1920x1080@60,2560x360,1"
        ];

        exec-once = [
          # ~/.config/hypr/xdg-portal-hyprland
          # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
          # exec-once = $HOME/.dotfiles/waybar/launch.sh
          "swww init"
          "ags -c ${config.xdg.configHome}/ags/simple-bar/config.js -b bar &"
          "ags -c ${config.xdg.configHome}/ags/applauncher/config.js -b app &"

          # "ags &"
          # "ags -c ${config.xdg.configHome}/simple-bar/config.js &"
          # exec = swww img $XDG_CACHE_HOME/current_wallpaper.jpg --transition-step 20 --transition-fps=20
          # exec-once = festival --server
          # exec-once = /usr/bin/emacs --daemon
          # exec-once = rclone --vfs-cache-mode writes mount OneDrive: ~/Documents/OneDrive & notify-send "OneDrive connected" "Microsoft OneDrive successfully mounted."  # establish connection to onedrive

        ];
        debug.disable_logs = false;

        input = {
          kb_layout = "us, dk";
          # kb_variant =
          # kb_model =
          kb_options = "grp:alt_shift_toggle, caps:swapescape";
          # kb_rules =

          follow_mouse = 1;

          touchpad = { natural_scroll = "no"; };

          numlock_by_default = true;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
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

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile =
            "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = "yes"; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true;
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "off";
        };

        "$mainMod" = "SUPER";

        bind = [
          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          ''$mainMod, E, exec, emacsclient -c -a "emacs"'' # open emacs
          "$mainMod, Q, exec, kitty" # open the terminal
          "$mainMod SHIFT, X, killactive," # close the active window
          "$mainMod, L, exec, swaylock" # Lock the screen
          "$mainMod, M, exec, killall wlogout || wlogout --protocol layer-shell" # show the logout window
          "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)
          "$mainMod, D, exec, thunar" # Show the graphical file browser
          "$mainMod, V, togglefloating," # Allow a window to float
          "$mainMod, F5, fullscreen"
          "$mainMod, SPACE, exec, ags -b app -t applauncher" # Show the graphicall app launcher
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle
          ''
            $mainMod, S, exec, killall grim || grim -g "$(slurp)" - | swappy -f - # take a screenshot''
          "$mainMod, F , exec, firefox"

          ", code:179, exec, flatpak run com.spotify.Client" # music key
          ", code:148, exec, kcalc" # calculator
          ", code:163, exec, thunderbird" # email
          ", code:152, exec, thunar" # file manager

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Mouse shortcuts
          # ", mouse_left, exec, wtype -M ctrl -M shift -P Tab -m ctrl -m shift"
          ", mouse_right, exec, wtype -M ctrl -P Tab -m ctrl"

        ];

      };
      extraConfig = ''
        #  _   _                  _                 _
        # | | | |_   _ _ __  _ __| | __ _ _ __   __| |
        # | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |
        # |  _  | |_| | |_) | |  | | (_| | | | | (_| |
        # |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
        #        |___/|_|
        # modified by: Rasmus Enevolden (2023)
        # -----------------------------------------------------------------



        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # -----------------------------------------------------------------
        # Autostart
        # -----------------------------------------------------------------

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

        # rules below would make the specific app transparent
        # windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
        # windowrulev2 = opacity 0.8 0.8,class:^(thunar)$
        # windowrulev2 = opacity 0.8 0.8,class:^(chromium)$
        # windowrulev2 = opacity 0.8 0.8,class:^(Code)$



        # bind = $mainMod SHIFT, W, exec, $HOME/.dotfiles/scripts/wallpaper-swaybg.sh
        # bind = $mainMod SHIFT, B, exec, $HOME/.dotfiles/waybar/launch.sh


        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow


        # Audio shortcuts [works only with spotify]
        # bind = , code:173, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
        # bind = , code:172 , exec ,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
        # bind = , code:171, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

        # binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        # binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

      '';
    };
  };

}
