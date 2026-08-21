{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.vaultwarden.enable = lib.mkEnableOption "enables vaultwarden";
  };

  config = lib.mkIf config.my.vaultwarden.enable {
    environment.systemPackages = with pkgs; [ sqlite ];

    services.vaultwarden = {
      enable = true;
      environmentFile = "/mnt/pass/vaultwarden/vaultwarden.env";
      backupDir = "/mnt/pass/vaultwarden/backup";
      dbBackend = "sqlite";
      config = {
        # DOMAIN = "https://bitwarden.example.com";
        # SIGNUPS_ALLOWED = false;

        # Vaultwarden currently recommends running behind a reverse proxy
        # (nginx or similar) for TLS termination, see
        # https://github.com/dani-garcia/vaultwarden/wiki/Hardening-Guide#reverse-proxying
        # > you should avoid enabling HTTPS via vaultwarden's built-in Rocket TLS support,
        # > especially if your instance is publicly accessible.
        #
        # A suitable NixOS nginx reverse proxy example config might be:
        #
        #     services.nginx.virtualHosts."bitwarden.example.com" = {
        #       enableACME = true;
        #       forceSSL = true;
        #       locations."/" = {
        #         proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        #       };
        #     };
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        ROCKET_LOG = "critical";

        # This example assumes a mailserver running on localhost,
        # thus without transport encryption.
        # If you use an external mail server, follow:
        #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        # SMTP_HOST = "127.0.0.1";
        # SMTP_PORT = 25;
        # SMTP_SSL = false;

        # SMTP_FROM = "admin@bitwarden.example.com";
        # SMTP_FROM_NAME = "example.com Bitwarden server";
      };
    };
  };
}
