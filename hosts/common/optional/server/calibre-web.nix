{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = { my.calibre-web.enable = lib.mkEnableOption "enables jellyfin"; };

  config = lib.mkIf config.my.calibre-web.enable {
    # https://nixos.wiki/wiki/Jellyfin
    services.calibre-web = {
      enable = true;
      openFirewall = true;
      # listen.port = 8083;
      listen = {
        ip = "0.0.0.0";
        port = 8083;
      };
    };
  };
}
