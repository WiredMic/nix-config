{
  pkgs,
  lib,
  config,
  inputs,
  cosmicLib,
  ...
}:
{
  # https://heitoraugustoln.github.io/cosmic-manager/getting-started/flakes.html
  imports = [ ];

  options = {
    my.cosmic.enable = lib.mkEnableOption "enables cosmic config";
  };

  config = lib.mkIf config.my.cosmic.enable {

    wayland.desktopManager.cosmic = {
      enable = true;

      appearance.toolkit = {
        icon_theme = "Papirus-Dark";

        monospace_font = {
          family = "JetBrains Mono";
          stretch = cosmicLib.cosmic.mkRON "enum" "Normal";
          style = cosmicLib.cosmic.mkRON "enum" "Normal";
          weight = cosmicLib.cosmic.mkRON "enum" "Normal";
        };
      };

      applets.time.settings = {
        military_time = true;
        first_day_of_week = 0;
        show_seconds = false;
      };

      compositor = {
        active_hint = true;
        autotile = true;
        autotile_behavior = cosmicLib.cosmic.mkRON "enum" "Global";
        descale_xwayland = false;

        cursor_follows_focus = true;
        focus_follows_cursor = true;
        focus_follows_cursor_delay = 0;

        # error: expected a list but found null: null
        # input_default = {
        #   acceleration = cosmicLib.cosmic.mkRON "optional" {
        #     profile = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Flat");
        #     speed = -0.03;
        #   };
        #   state = cosmicLib.cosmic.mkRON "enum" "Enabled";
        # };

        input_touchpad = {
          state = cosmicLib.cosmic.mkRON "enum" "Enabled";
          scroll_config = cosmicLib.cosmic.mkRON "optional" {
            method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "TwoFinger");
            natural_scroll = cosmicLib.cosmic.mkRON "optional" true;
            scroll_button = cosmicLib.cosmic.mkRON "optional" null;
            scroll_factor = cosmicLib.cosmic.mkRON "optional" null;
          };

          disable_while_typing = cosmicLib.cosmic.mkRON "optional" true;
          click_method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Clickfinger");

          tap_config = cosmicLib.cosmic.mkRON "optional" {
            enabled = true;
            button_map = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "LeftMiddleRight");
            drag = true;
            drag_lock = true;
          };
        };

        keyboard_config = {
          numlock_state = cosmicLib.cosmic.mkRON "enum" "BootOn";
        };

        workspaces = {
          workspace_layout = cosmicLib.cosmic.mkRON "enum" "Horizontal";
          workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";
        };
      };

      panels = [
        {
          name = "Panel";
          anchor = cosmicLib.cosmic.mkRON "enum" "Top";
          anchor_gap = false;
          autohide = null;

          background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
          opacity = 0.5;

          expand_to_edges = true;
          margin = 0;

          size = cosmicLib.cosmic.mkRON "enum" "XS";

          output = cosmicLib.cosmic.mkRON "enum" "All";

          plugins_center = cosmicLib.cosmic.mkRON "optional" [
            "com.system76.CosmicAppletTime"
          ];
          plugins_wings = cosmicLib.cosmic.mkRON "optional" (
            cosmicLib.cosmic.mkRON "tuple" [
              [
                "com.system76.CosmicPanelWorkspacesButton"
                "com.system76.CosmicAppletWorkspaces"
              ]
              [
                "com.system76.CosmicAppletStatusArea"
                "com.system76.CosmicAppletAudio"
                "com.system76.CosmicAppletBluetooth"
                "com.system76.CosmicAppletNetwork"
                "com.system76.CosmicAppletBattery"
                "com.system76.CosmicAppletNotifications"
                "com.system76.CosmicAppletPower"
              ]
            ]
          );

        }
      ];

    };

    programs.cosmic-applibrary.enable = false;
    programs.cosmic-edit.enable = false;

    programs.cosmic-ext-calculator = {
      enable = true;
      package = pkgs.cosmic-ext-calculator;
      settings.app_theme = cosmicLib.cosmic.mkRON "enum" "System";
    };

    programs.cosmic-ext-tweaks = {
      enable = true;
      package = pkgs.cosmic-ext-tweaks;
      settings.app_theme = cosmicLib.cosmic.mkRON "enum" "System";
    };

    programs.cosmic-files = {
      enable = true;
      package = pkgs.cosmic-files;
      settings.app_theme = cosmicLib.cosmic.mkRON "enum" "System";
    };

  };
}
