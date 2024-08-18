{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = { my.jellyfin.enable = lib.mkEnableOption "enables jellyfin"; };

  config = lib.mkIf config.my.jellyfin.enable {
    # https://nixos.wiki/wiki/Jellyfin
    services.jellyfin = {
      enable = true;
      openFirewall = true; # port 8096
    };
  };
}
