{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.nextcloud.enable = lib.mkEnableOption "enables nextcloud";
  };

  config = lib.mkIf config.my.nextcloud.enable {
    # https://nixos.wiki/wiki/Nextcloud
    services.nextcloud = {
      enable = true;
      # package = pkgs.nextcloud29;
      hostName = "nextcloud";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
    };

    services.nginx = {
      enable = false;
      virtualHosts."nextcloud".listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
    };
  };
}
