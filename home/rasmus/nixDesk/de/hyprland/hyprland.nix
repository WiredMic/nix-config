{ pkgs, config, lib, userSettings, inputs, ... }: {
  imports = [
    # inputs.split-monitor-workspaces.homeManagerModules.default
  ];

  options = {
    my.hyprland.enable = lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.hyprland.enable {
    home.packages = with pkgs; [ wev kcalc ];

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

        exec-once = [ ];

        input = {

          touchpad = { natural_scroll = "no"; };
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "off";
        };

        bind = [
          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

          ", code:179, exec, flatpak run com.spotify.Client" # music key
          ", code:148, exec, kcalc" # calculator
          ", code:163, exec, thunderbird" # email
          ", code:152, exec, thunar" # file manager

          # Audio shortcuts [works only with spotify]
          ", code:173, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
          ", code:172 , exec ,dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
          " code:171, execr, dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
        ];

      };
      extraConfig = "";
    };
  };

}
