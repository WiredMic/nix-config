{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.calibre-server.enable = lib.mkEnableOption "enables calibre-server";
  };

  config = lib.mkIf config.my.calibre-server.enable {
    services.calibre-server = {
      enable = true;
      package = pkgs.calibre;
      openFirewall = true;
      port = 8184;
      libraries = [ "/mnt/ZPOOL0/share/Media/Calibre Library" ];
    };
  };
}
