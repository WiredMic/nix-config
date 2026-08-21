{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # ./qbittorrent-nox.nix
  ];

  options = {
    my.torrent.enable = lib.mkEnableOption "enables torrent";
  };

  config = lib.mkIf config.my.torrent.enable {
    users.groups.torrent = { };
    # prowlarr ( find tv shows )
    services.prowlarr = {
      enable = true;
      openFirewall = true;
      settings.server.port = 9696;
    };

    # (get around prowlarr being a bot)
    services.flaresolverr = {
      enable = true;
      package = pkgs.flaresolverr;
      port = 8191;
      openFirewall = true;
    };

    # sonarr ( download tv shows )
    services.sonarr = {
      enable = true;
      group = "torrent";
      openFirewall = true;
      settings.server.port = 8989;
    };

    # radarr ( download movies )
    services.radarr = {
      enable = true;
      group = "torrent";
      openFirewall = true;
      settings.server.port = 7878;
    };

    # tdarr ( transcoding manager )
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "tdarr-server"
        "tdarr-node"
        "unrar"
      ];
    services.tdarr = {
      enable = true;
      package = pkgs.tdarr.override {
        tdarr-server = pkgs.tdarr-server.overrideAttrs (_: {
          autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
        });
      };
      group = "torrent";
      server = {
        openFirewall = true;
        webUIPort = 8265;
      };
      nodes.main = {
        workers.transcodeGPU = 1;
        workers.transcodeCPU = 1;
      };
    };

    # bazarr ( subtitle manager )
    services.bazarr = {
      enable = false;
      group = "torrent";
      openFirewall = true;
      listenPort = 6767;
    };

    # sabnzbd ( the usenet manager )
    services.sabnzbd = {
      enable = true;
      package = pkgs.sabnzbd;
      group = "torrent";
      openFirewall = true;
    };

    # qbittorrent ( the torrent manager )
    services.qbittorrent = {
      # find temp password in systemctl status
      enable = lib.mkDefault true;
      group = "torrent";
      openFirewall = true;
      webuiPort = 5656;
      serverConfig = {
        Preferences = {
          WebUI = {
            Username = "admin";
            Password_PBKDF2 = "@ByteArray(vxiqo8FJ2LdXw1zOXx0iZw==:1eBlgOBg2vputcwYDL3OjZ/ILNi37v+f8WD+lijvmb/zeV4uJiY1+DDcV/0ts+yCzd2JdyHjTuKvoDx6PWfz1A==)";
          };
          General.Locale = "en";
        };

        Application = {
          FileLogger = {
            Age = "1";
            AgeType = "1";
            Backup = "true";
            DeleteOld = "true";
            Enabled = "true";
            MaxSizeBytes = "66560";
            Path = "/mnt/ZPOOL0/share/Backup/qBittorrent";
          };
        };

        BitTorrent = {
          Session = {
            # InterfaceName = "tailscale0";
            DefaultSavePath = "/mnt/ZPOOL0/share/Media/Downloads";
            TempPath = "/mnt/ZPOOL0/share/Backup/qBittorrent/incomplete_downloads";
            TempPathEnabled = true;
            FinishedTorrentExportDirectory = "/mnt/ZPOOL0/share/Backup/qBittorrent/complete_downloads";
            TorrentExportDirectory = "/mnt/ZPOOL0/share/Backup/qBittorrent/torrent_files";
          };
        };
      };
    };

    # Seerr
    services.seerr = {
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
