{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.blocky.enable = lib.mkEnableOption "enables blocky as an dns blocker";
  };

  config = lib.mkIf config.my.blocky.enable {
    # virtualisation.docker.enable = true;
    # virtualisation.oci-containers.backend = "docker";
    # users.extraGroups.docker.members = [ "rasmus" ];

    # virtualisation.oci-containers.containers."blocky" = {
    #   autoStart = true;
    #   image = "spx01/blocky";
    #   environment = { TZ = "Europe/Copenhagen"; };
    #   ports = [ "53:53/tcp" "53/53/udp" "4000:4000/tcp" ];
    #   volumes = [
    #     "/etc/localtime:/etc/localtime:ro"
    #     "./${
    #       (pkgs.formats.yaml { }).generate "config.yaml" {
    #         ports.dns = 53; # Port for incoming DNS Queries.
    #         upstreams.groups.default = [
    #           "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
    #           # "1.1.1.1"
    #         ];
    #       }
    #     }:/app/config.yaml"
    #   ];
    # };

    services.blocky = {
      # this will not work because mullvad need rsovled to work
      enable = true;
      # https://0xerr0r.github.io/blocky/latest/configuration/
      settings = {
        ports.dns = 53; # Port for incoming DNS Queries.
        upstreams.groups.default = [
          "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
          # "1.1.1.1"
        ];
        customDNS = {
          mapping = {
            "jellyfin.box" = "192.168.86.102:8096";
            "jellyseerr.box" = "192.168.86.102:5056";
            "prowler.box" = "192.168.86.102:9696";
            "sonarr.box" = "192.168.86.102:8989";
            "radarr.box" = "192.168.86.102:7878";
            "qbittorrent.box" = "192.168.86.102:5656";

          };
        };

        # For initially solving DoH/DoT Requests when no system Resolver is available.
        #   bootstrapDns = {
        #     upstream = "https://one.one.one.one/dns-query";
        #     ips = [ "1.1.1.1" "1.0.0.1" ];
        #   };
        #   # #Enable Blocking of certian domains.
        #   blocking = {
        #     blackLists = {
        #       #Adblocking
        #       ads = [
        #         "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
        #         "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        #       ];
        #       #You can add additional categories
        #     };
        #     #Configure what block categories are used
        #     clientGroupsBlock = { default = [ "ads" ]; };
        #   };
      };
    };
  };
}
