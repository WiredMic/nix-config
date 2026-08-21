{
  config,
  lib,
  pkgs,
  ...
}:

let
  nixserver-url = "192.168.86.65";

  qbittorrent-url = "${nixserver-url}:${toString config.services.qbittorrent.webuiPort}";
  seerr-url = "${nixserver-url}:${toString config.services.seerr.port}";
  prowlarr-url = "${nixserver-url}:${toString config.services.prowlarr.settings.server.port}";
  flaresolverr-url = "${nixserver-url}:${toString config.services.flaresolverr.port}";
  sonarr-url = "${nixserver-url}:${toString config.services.sonarr.settings.server.port}";
  radarr-url = "${nixserver-url}:${toString config.services.radarr.settings.server.port}";
  tdarr-url = "${nixserver-url}:${toString config.services.tdarr.server.webUIPort}";

  jellyfin-url = "${nixserver-url}:8096";
  calibre-web-url = "${nixserver-url}:${toString config.services.calibre-web.listen.port}";
  audiobookshelf-url = "${nixserver-url}:${toString config.services.audiobookshelf.port}";

  immich-url = "${nixserver-url}:${toString config.services.immich.port}";

  prometheus-url = "${nixserver-url}:${toString config.services.seerr.port}";

in
{
  options = {
    my.homepage.enable = lib.mkEnableOption "enables audiobookshelf";
  };

  config = lib.mkIf config.my.homepage.enable {

    services.homepage-dashboard = rec {

      enable = true;
      openFirewall = true;
      listenPort = 8082;
      allowedHosts = "localhost:${toString config.services.homepage-dashboard.listenPort},127.0.0.1:${toString config.services.homepage-dashboard.listenPort},${nixserver-url}:${toString config.services.homepage-dashboard.listenPort}";
      # https://gethomepage.dev/latest/configs/settings/
      settings = {
        layout = {
          "Media" = {
            style = "row";
            columns = "4";
          };
        };
      };
      services = [
        {
          "Media Management" = [
            {
              "Seerr" = {
                icon = "seerr.png";
                description = "Get Movies and Shows";
                href = "http://${seerr-url}/";
                ping = seerr-url;
                widget = {
                  type = "jellyseerr";
                  url = "http://${seerr-url}";
                  key = "MTc3NzgyMDQyNzA0ODBkODk4MTg4LTI1NDgtNGU4Yi05MjZiLTlmMDM5NmY1ZGI5Mw==";
                };
              };
            }

            {
              "qbittorrent" = {
                icon = "qbittorrent.png";
                description = "qbittorrent";
                href = "http://${qbittorrent-url}/";
                ping = qbittorrent-url;
                # https://gethomepage.dev/latest/widgets/services/qbittorrent/
                widget = {
                  type = "qbittorrent";
                  fields = ''["leech", "download", "seed", "upload"]'';
                  url = "http://${qbittorrent-url}/api/v2/torrents/info";
                  username = "admin";
                  password = "Y77qT,w||ua>F&{>U(%Mp^2/[4W3-Aj6";
                };
              };
            }

            {
              "Prowlarr" = {
                icon = "prowlarr.png";
                description = "Index Management";
                href = "http://${prowlarr-url}/";
                widget = {
                  type = "prowlarr";
                  fields = ''["numberOfGrabs", "numberOfQueries", "numberOfFailGrabs", "numberOfFailQueries"]'';
                  url = "http://${prowlarr-url}";
                  key = "d416401e86e74fc3b614410a6ce6b5a0";
                };
              };
            }

            {
              "Flaresolverr" = {
                icon = "flaresolverr.png";
                description = "Bot management";
                href = "http://${flaresolverr-url}/";
              };
            }

            {
              "Sonarr" = {
                icon = "sonarr.png";
                description = "Series management";
                href = "http://${sonarr-url}/";
                widget = {
                  type = "sonarr";
                  url = "http://${sonarr-url}";
                  key = "e33c0082587b4fd185db2b9198b0fc93";
                };
              };
            }

            {
              "Radarr" = {
                icon = "radarr.png";
                description = "Movies management";
                href = "http://${radarr-url}/";
                widget = {
                  type = "radarr";
                  url = "http://${radarr-url}";
                  key = "c1f749f072d2438bb320e5952ee369fd";
                };
              };
            }

            {
              "Tdarr" = {
                icon = "tdarr.png";
                description = "Pretranscoder";
                href = "http://${tdarr-url}/";
                widget = {
                  type = "tdarr";
                  url = "http://${tdarr-url}";
                  key = "f93f797c4e7f48338c2f5bdf6330a273";
                };
              };
            }
          ];
        }

        {
          "Libraries" = [
            {
              "Audiobookshelf" = {
                icon = "audiobookshelf.png";
                description = "Audiobooks and ebooks";
                href = "http://${audiobookshelf-url}/audiobookshelf/";
                widget = {
                  type = "audiobookshelf";
                  url = "http://${audiobookshelf-url}";
                  fields = ''["books", "booksDuration"]''; # cannot use this right now https://discourse.nixos.org/t/cannot-ecape-quotes-correctly-in-yaml-out-of-pkgs-formats-yaml/51021
                  key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXlJZCI6IjVhZWQzOTVkLWJiZTEtNDJiNy1hNTMxLTQ1MzFmZjMzNTQ1MyIsIm5hbWUiOiJob21lcGFnZSIsInR5cGUiOiJhcGkiLCJpYXQiOjE3NzgzMjUxNTV9.xOhUEKQCpQJ7t5zkwgxTqGm7S7MSabgBqa4cAyhAAUk";
                };
              };
            }

            {
              "Jellyfin" = {
                icon = "jellyfin.png";
                description = "Movies and Shows";
                href = "http://${jellyfin-url}/";
              };
            }

            {
              "Calibre-web" = {
                icon = "calibre-web.png";
                description = "Book and PDFs";
                href = "http://${calibre-web-url}/";
              };
            }

          ]
          ++ lib.optional config.services.immich.enable {
            "Immich" = {
              icon = "immich.png";
              description = "Personal Images and Videos";
              href = "http://${immich-url}/";
              widget = {
                type = "immich";
                fields = ''["users" ,"photos", "videos", "storage"]'';
                url = "http://${immich-url}/";
                key = "";
                version = "2"; # optional, default is 1
              };
            };
          };
        }
        {
          "Monitoring" = [
            {
              "Prometheus" = {
                icon = "https://avatars.githubusercontent.com/u/3380462?s=200&v=4";
                description = "Prometheus";
                href = "http://${prometheus-url}/";
                widget = {
                  type = "prometheus";
                  fields = ''["targets_up", "targets_down", "targets_total"]'';
                  url = "http://${prometheus-url}";
                };
              };
            }
          ];
        }
      ];

    };
  };
}
