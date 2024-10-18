{ config, lib, pkgs, ... }:

{
  options = {
    hyprland.swayosd.enable =
      lib.mkEnableOption "enables swayosd for sound and stuff in hyprland";
  };

  config = lib.mkIf config.hyprland.swayosd.enable {
    home.packages = with pkgs;
      [
        # brightnessctl
      ];

    # Notification daemon
    services.swayosd = {
      enable = true;
      package = pkgs.swayosd;
      stylePath = null;
      topMargin = null;
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          # OSD
          "swayosd-server"
          "swayosd-libinput-backend"
        ];

        bind = [

          # Microphone and Audio (single press)
          # ",XF86AudioMicMute, exec, wpctl -- set-source-mute 0 toggle"
          # ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Microphone and Audio (single press)
          ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ];

        binde = [
          # Audio
          # Audio
          # ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%-"
          # ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+ # To raise the volume, with a limit of 150%"
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 120"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 120"

          # Brightness
          # ",XF86MonBrightnessDown, exec,brightnessctl s 10%-"
          # ",XF86MonBrightnessUp, exec,brightnessctl s +10% "
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ];

      };
    };
  };
}
