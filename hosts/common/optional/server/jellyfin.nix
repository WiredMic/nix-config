{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = { my.jellyfin.enable = lib.mkEnableOption "enables jellyfin"; };

  config = lib.mkIf config.my.jellyfin.enable {
    # https://nixos.wiki/wiki/Jellyfin
    services.jellyfin = {
      enable = true;
      openFirewall = true; # port 8096
      user = "jellyfin";
    };

    users.users.jellyfin = {
      description = "Jellyfins user";
      extraGroups = [ "render" "video" ];
    };

    environment.systemPackages =
      [ pkgs.jellyfin pkgs.jellyfin-web pkgs.jellyfin-ffmpeg ];

    # AMD GPU
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-vaapi-driver libvdpau-va-gl ];
    };
  };
}
