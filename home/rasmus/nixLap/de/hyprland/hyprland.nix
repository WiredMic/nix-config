{
  pkgs,
  config,
  lib,
  userSettings,
  inputs,
  ...
}:
{
  imports = [
    # inputs.split-monitor-workspaces.homeManagerModules.default
  ];

  options = {
    my.hyprland.enable = lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.hyprland.enable {
    home.packages = with pkgs; [
      wev
      rose-pine-hyprcursor
    ];

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
          "desc:Philips Consumer Electronics Company 231PQPY UHB1438011769,1920x1080@60.00000, 0x-1080, 1"
          "desc:LG Electronics LG TV SSCR2 0x01010101,3840x2160@60.00000,auto,2"
          ", preferred, auto, 1"
        ];

        # Set GPUs
        env = [
          "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor"
          "HYPRCURSOR_SIZE,24"
        ];

        #   exec-once = [
        #     # ~/.config/hypr/xdg-portal-hyprland
        #     # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #     "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #   ];

        input = {
          touchpad = {
            natural_scroll = "yes";
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        # https://wiki.hypr.land/0.52.0/Configuring/Gestures/
        gesture = [
          "4, horizontal, workspace,scale = 4"
        ];

        bind = [
          #     # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          #     "$mainMod, L, exec, swaylock" # Lock the screen
          #     "$mainMod SHIFT, M, exit," # Exit Hyprland all together no (force quit Hyprland)

        ];
      };
    };
  };
}
