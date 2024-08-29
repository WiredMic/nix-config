{ config, lib, pkgs, ... }:

{

  options = {
    my.distrobox.enable =
      lib.mkEnableOption "enables distrobox with podman as backend";
  };

  config = lib.mkIf config.my.distrobox.enable {

    environment.systemPackages = with pkgs; [ distrobox ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.variables = { DBX_CONTAINER_MANAGER = "podman"; };

  };
}
