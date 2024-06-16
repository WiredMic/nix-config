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

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    # nix.settings = {
    #   substituters = ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };

    hardware.opengl = {
      package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa.drivers;

      # if you also want 32-bit support (e.g for Steam)
      driSupport32Bit = true;
      package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa.drivers;
    };
    # Optional, hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

}

