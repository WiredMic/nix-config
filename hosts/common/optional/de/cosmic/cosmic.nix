{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ];

  options = {
    de.cosmic.enable = lib.mkEnableOption "enables cosmic config";
  };

  config = lib.mkIf config.de.cosmic.enable {

    nixpkgs.overlays = [
      (_: prev: {
        cosmic-comp = prev.cosmic-comp.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./no_ssd.patch ];
        });
      })
    ];

    services.desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-term
      cosmic-store
      cosmic-edit
      cosmic-wallpapers
    ];

    services.gnome.gcr-ssh-agent.enable = false;
  };
}
