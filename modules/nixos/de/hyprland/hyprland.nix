{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
  ];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = 

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

