{ pkgs, lib, config, ... }: {
  imports = [ ];

  options = { my.sddm.enable = lib.mkEnableOption "enables sddm config"; };

  config = lib.mkIf config.my.sddm.enable {
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5.qtgraphicaleffects
      (callPackage ./sddm-suger-dark.nix { })
      (callPackage ./where-is-my-sddm-theme-tree.nix { })
      where-is-my-sddm-theme
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      theme = "where-is-my-sddm-theme-tree";
    };

    services.xserver.displayManager.setupCommands = ''
      xrandr --output DP-1 --mode 2560x1440 --rate 144 -pos 0x0 --rotate normal
      xrandr --output DP-2 --off
      xrandr --output HDMI-1 --off
    '';

    # Set Icon Avatar
    # system.activationScripts.script.text = ''
    #   cp ${./rasmus.face.png} /var/lib/AccountsService/icons/rasmus
    # '';
  };

}
