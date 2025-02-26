{ config, lib, pkgs, pkgs-unstable, ... }:

{

  options = {
    my.onedrive.enable = lib.mkEnableOption "enables onedrive with rclone";
  };

  config = lib.mkIf config.my.onedrive.enable {
    # environment.systemPackages = [ pkgs.rclone ];
    # fileSystems."/mnt/onedrive" = {
    #   device = "onedrive";
    #   fsType = "rclone";
    #   options = [
    #     "nodev"
    #     "nofail"
    #     "allow_other"
    #     "args2env"
    #     "config=/etc/rclone/onedrive.conf"
    #   ];
    # };

    services.onedrive.enable = true;
    services.onedrive.package = pkgs-unstable.onedrive;
  };
}
