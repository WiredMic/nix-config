{ pkgs, config, lib, userSettings, inputs, ... }: {
  imports = [ inputs.nix-colors.homeManagerModules.default ];

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

      kdePackages.qt6ct
      # (callPackage ./base16-qt5ct.nix { })
      adwaita-qt6
      kdePackages.qtstyleplugin-kvantum
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

    # Theming
    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
      # style.name = "";

    };
    colorScheme = inputs.nix-colors.colorSchemes."${userSettings.style-color}";
    # stylix.homeManagerIntegration.followSystem = true;
    xdg.configFile = {
      "qt6ct" = {
        enable = true;
        source = pkgs.stdenv.mkDerivation {
          name = "base16-qt5ct";
          # version = "1.2";
          dontBuild = true;
          src = pkgs.fetchFromGitHub {
            owner = "mnussbaum";
            repo = "base16-qt5ct";
            rev = "a2ccf3fa3fb7e1c1c82f23e629e41aee0dc2bede";
            hash = "sha256-/mfhvmUFemLmYO9wQfDUnr7w3czUbF69fwZqP4+umMs=";
          };
          buildInputs = [ pkgs.adwaita-qt6 ];
          installPhase = ''
            mkdir -p $out
            cp -r $src/colors/. $out/colors
            echo "${config.colorScheme.palette.base01}" | cat - > test.test
            cat > $out/qt6ct.conf << EOF
              [Appearance]
              color_scheme_path=/home/rasmus/.config//qt6ct/colors/base16-${userSettings.style-color}.conf
              custom_palette=true
              standard_dialogs=default
              style=kvantum-dark

              [Fonts]
              fixed="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
              general="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

              [Interface]
              activate_item_on_single_click=1
              buttonbox_layout=0
              cursor_flash_time=1000
              dialog_buttons_have_icons=1
              double_click_interval=400
              gui_effects=@Invalid()
              keyboard_scheme=2
              menus_have_icons=true
              show_shortcuts_in_context_menus=true
              stylesheets=@Invalid()
              toolbutton_style=4
              underline_shortcut=1
              wheel_scroll_lines=3

              [SettingsWindow]
              geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x4\xe2\0\0\x5Q\0\0\0\0\0\0\0\0\0\0\x4\xff\0\0\x5}\0\0\0\0\x2\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\x4\xe2\0\0\x5Q)

              [Troubleshooting]
              force_raster_widgets=1
              ignored_applications=@Invalid()
            EOF
          '';
        };
      };
    };

    # xdg.configFile."Kvantum/KvArcDark" = {
    #   enable = true;
    #   source = pkgs.stdenv.mkDerivation {
    #     name = "KvArcDark";
    #     # version = "1.2";
    #     dontBuild = true;
    #     src = ./KvArcDark;
    #     installPhase = ''
    #       mkdir -p $out
    #       cp -r $src/. $out
    #       cd $out
    #       sed -i -E "s/^window.color=.*$/window.color=#${config.colorScheme.palette.base00}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^base.color=.*$/base.color=#${config.colorScheme.palette.base00}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^alt.base.color=.*$/alt.base.color=#${config.colorScheme.palette.base01}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^button.color=.*$/button.color=#${config.colorScheme.palette.base04}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^light.color=.*$/light.color=#${config.colorScheme.palette.base06}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^mid.light.color=.*$/mid.light.color=#${config.colorScheme.palette.base07}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^dark.color=.*$/dark.color=#${config.colorScheme.palette.base04}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^mid.color=.*$/mid.color=#${config.colorScheme.palette.base05}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^highlight.color=.*$/highlight.color=#${config.colorScheme.palette.base03}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^inactive.highlight.color=.*$/inactive.highlight.color=#${config.colorScheme.palette.base01}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^text.color=.*$/text.color=#${config.colorScheme.palette.base04}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^window.text.color=.*$/window.text.color=#${config.colorScheme.palette.base01}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^button.text.color=.*$/button.text.color=#${config.colorScheme.palette.base01}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^disabled.text.color=.*$/disabled.text.color=#${config.colorScheme.palette.base01}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^tooltip.text.color=.*$/tooltip.text.color=#${config.colorScheme.palette.base04}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^highlight.text.color=.*$/highlight.text.color=#${config.colorScheme.palette.base05}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^link.color=.*$/link.color=#${config.colorScheme.palette.base0D}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^link.visited.color=.*$/link.visited.color=#${config.colorScheme.palette.base0E}/g" KvArcDark.kvconfig
    #       sed -i -E "s/^progress.indicator.text.color=.*$/progress.indicator.text.color=#${config.colorScheme.palette.base07}/g" KvArcDark.kvconfig
    #     '';
    #   };
    # };
    # # environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";

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
          "swww init"
          "ags -c ${config.xdg.configHome}/ags/simple-bar/config.js -b bar &"
          "ags -c ${config.xdg.configHome}/ags/applauncher/config.js -b app &"

          # "swww img ${
          #   ../../../../../../wallpapers
          # }/chill-forrest.jpg --transition-step 20 --transition-fps=20"
          # exec-once = festival --server
          # exec-once = rclone --vfs-cache-mode writes mount OneDrive: ~/Documents/OneDrive & notify-send "OneDrive connected" "Microsoft OneDrive successfully mounted."  # establish connection to onedrive

        ];
        exec = [
          "swww img ${
            ../../../../../../wallpapers
          }/chill-forrest.jpg --transition-step 20 --transition-fps=20"
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
          ", mouse_left, exec, wtype -M ctrl -M shift -P Tab -m ctrl -m shift"
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
