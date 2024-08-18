{ config, lib, pkgs, ... }:

{

  imports = [ ./qbittorrent-nox.nix ];

  options = { my.torrent.enable = lib.mkEnableOption "enables torrent"; };

  config = lib.mkIf config.my.jellyfin.enable {
    users.groups.torrent = { };
    # prowlarr ( find tv shows )
    services.prowlarr = {
      enable = true;
      openFirewall = true; # port 9696
    };
    # sonarr ( download tv shows )
    services.sonarr = {
      enable = true;
      group = "torrent";
      openFirewall = true; # port 8989
    };
    # radarr ( download movies )
    services.radarr = {
      enable = true;
      group = "torrent";
      openFirewall = true; # port 7878
    };
    # bazarr ( subtitle manager )
    services.bazarr = {
      enable = false;
      group = "torrent";
      openFirewall = true;
      listenPort = 6767;
    };
    # qbittorrent ( the torrent manager )
    services.qbittorrent = { # find temp password in systemctl status
      enable = true;
      group = "torrent";
      openFirewall = true;
      port = 5656;
    };
    services.jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 5055;
    };

    # Folder structure on NAS
    # media
    # ├─ Downloads  ( qbittorrent)
    # ├─ Movies     ( radarr )
    # ├─ TV Shows   ( sonarr )

    # prowlarr socks5 mullvap vpn
    # https://mullvad.net/en/help/socks5-proxy
    services.mullvad-vpn.enable = true;
    services.resolved.enable = true;

  };
}
