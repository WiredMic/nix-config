{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.immich.enable = lib.mkEnableOption "enables immich";
  };

  config = lib.mkIf config.my.immich.enable {
    services.immich = {
      enable = true;
      package = pkgs.immich;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
    };
  };
}
