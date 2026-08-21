{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.nginx.enable = lib.mkEnableOption "enables nginx";
  };

  config = lib.mkIf config.my.nginx.enable {
    # security.acme.defaults.email = "rasmus@enev.dk";
    # security.acme.acceptTerms = true;

    services.nginx = {
      enable = false;

      # Use recommended settings
      recommendedGzipSettings = true;

      virtualHosts."jellyfin.example.com" = {
        # enableACME = true;
        # forceSSL = true# ;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };
  };
}
