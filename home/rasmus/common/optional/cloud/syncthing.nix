{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.syncthing.enable = lib.mkEnableOption "enables syncthing to sync between my devices";
  };

  config = lib.mkIf config.my.syncthing.enable {
    # Syncthing is avaliable at port 8384
    services.syncthing = {
      enable = true;
      package = pkgs.syncthing;
      guiAddress = "127.0.0.1:8384";
      # openDefaultPorts = true; # TCP/UDP 22000 for transfers and UDP 21027 for discovery
      # settings = {
      #   options.localAnnouncePort = "22000";
      # };
    };
  };
}
