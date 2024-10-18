{ config, lib, pkgs, ... }:

{

  options = {
    hyprland.hyprshot.enable =
      lib.mkEnableOption "enables screenshot with hyprshor in hyprland";
  };

  config = lib.mkIf config.hyprland.hyprshot.enable {
    home.packages = with pkgs; [
      hyprshot

      # Depentencies
      jq # (to parse and manipulate json)
      grim # (to take the screenshot)
      slurp # (to select what to screenshot)
      wl-clipboard-rs # (to copy screenshot to clipboard)
      libnotify # (to get notified when a screenshot is saved)
      hyprpicker # (to freeze the screen contents with the --freeze flag)

      # Manipulate after
      swappy
    ];

    wayland.windowManager.hyprland = {

      settings = {
        bind = [
          "$mainMod, S , exec, pkill hyprshot || hyprshot --freeze --mode=region --raw --clipboard-only | swappy -f -"
          "$mainMod, PRINT , exec, pkill hyprshot || hyprshot --freeze --mode=window --raw --clipboard-only | swappy -f -"
        ];
      };
    };

    home.sessionVariables = {
      HYPRSHOT_DIR = "${config.home.homeDirectory}/Pictures";
    };
  };
}
