{ config, lib, pkgs, ... }:

{

  imports = [ ./jellyfin.nix ./audiobookshelf.nix ./torrent.nix ./calibre-web.nix ];

  my.jellyfin.enable = lib.mkDefault false;
  my.audiobookshelf.enable = lib.mkDefault false;
  my.torrent.enable = lib.mkDefault false;
  my.calibre-web.enable = lib.mkDefault false;

}
