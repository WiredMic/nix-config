{ config, lib, pkgs, ... }:

{

  options = {
    my.codex.enable =
      lib.mkEnableOption "enables codex as a comic book manager";
  };

  config = lib.mkIf config.my.codex.enable {

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";
    users.extraGroups.docker.members = [ "rasmus" ];

    virtualisation.oci-containers.containers."codex" = {
      autoStart = true;
      image = "docker.io/ajslater/codex";
      ports = [ "9810:9810" ];
      environment = { TZ = "Europe/Copenhagen"; };
      volumes = [
        "/media/Comics/codex-config:/config"
        # "/media/Comics:/comics:ro" # This does not work
      ];
    };
  };
}
