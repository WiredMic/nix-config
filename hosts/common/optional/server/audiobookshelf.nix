{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = {
    my.audiobookshelf.enable = lib.mkEnableOption "enables audiobookshelf";
  };

  config = lib.mkIf config.my.audiobookshelf.enable {
    services.audiobookshelf = {
      enable = true;
      port = 8234;
      host = "0.0 0.0";
      openFirewall = true;
    };
  };

}
