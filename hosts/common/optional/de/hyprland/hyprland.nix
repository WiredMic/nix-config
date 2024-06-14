{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
  ];
  options = {
    de.hyprland.enable = 
      lib.mkEnableOption "enables hyprland config";
  };

  config = lib.mkIf config.de.hyprland.enable {
    # https://wiki.hyprland.org/Nix/

    # nix.settings = {
    #   substituters = ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };


    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

}

