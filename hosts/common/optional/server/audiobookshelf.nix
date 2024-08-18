{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = {
    my.audiobookshelf.enable = lib.mkEnableOption "enables audiobookshelf";
  };

  config = lib.mkIf config.my.audiobookshelf.enable {
    # virtualisation.docker.enable = true;
    # virtualisation.oci-containers.backend = "docker";

    # virtualisation.oci-containers.containers."audiobookshelf" = {
    #   autoStart = true;
    #   image = "ghcr.io/advplyr/audiobookshelf:latest";
    #   environment = {
    #     AUDIOBOOKSHELF_UID = "99";
    #     AUDIOBOOKSHELF_GID = "100";
    #   };
    #   ports = [ "13378:80" ];
    #   volumes = [
    #     "/media/Audiobooks:/audiobooks"
    #     "/media/Podcasts:/podcasts"
    #     "/media/Containers/Audiobookshelf/config:/config"
    #     "/media/Containers/Audiobookshelf/audiobooks:/metadata"
    #   ];
    # };

    services.audiobookshelf = {
      enable = true;
      port = 8234;
      host = "0.0 0.0";
      openFirewall = true;
    };
  };

}
