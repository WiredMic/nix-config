{ config, lib, pkgs, ... }:

{

  imports = [
    ./jellyfin.nix
    ./audiobookshelf.nix
    ./torrent.nix
    ./calibre-web.nix
    # ./nginx.nix
    # ./vaultwarden.nix
    # ./nextcloud.nix
    ./blocky.nix
    # ./homepage.nix
    ./codex.nix
    # ./immich.nix
  ];

  my.jellyfin.enable = lib.mkDefault false;
  my.audiobookshelf.enable = lib.mkDefault false;
  my.torrent.enable = lib.mkDefault false;
  my.calibre-web.enable = lib.mkDefault false;
  # my.vaultwarden.enable = lib.mkDefault false;
  # my.nginx.enable = lib.mkDefault false;
  # my.nextcloud.enable = lib.mkDefault false;
  my.blocky.enable = lib.mkDefault false;
  # my.homepage.enable = lib.mkDefault false;
  my.codex.enable = lib.mkDefault false;
  # my.immich.enable = lib.mkDefault false;

}
