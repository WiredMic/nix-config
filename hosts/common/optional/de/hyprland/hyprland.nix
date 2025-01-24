{ config, pkgs, lib, inputs, ... }: {
  imports = [ ];
  options = {
    de.hyprland.enable = lib.mkEnableOption "enables hyprland config";
  };

  config = lib.mkIf config.de.hyprland.enable {
    # https://wiki.hyprland.org/Nix/

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
