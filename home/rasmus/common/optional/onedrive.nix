{ config, lib, pkgs, ... }:

{

  options = {
    my.onedrive.enable = lib.mkEnableOption "enables onedrive with rclone";
  };

  config = lib.mkIf config.my.onedrive.enable {
    home.packages = with pkgs; [ rclone ];

    systemd.user.services.onedrive = {
      Unit = {
        Description = "Enables OneDrive with rclone config from outside nix.";
        After = [ "network-online.target" ];
      };
      Service = {
        Type = "notify";
        ExecStartPre = "/usr/bin/env mkdir -p %h/OneDrive";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/onedrive.conf --vfs-cache-mode writes --ignore-checksum mount "OneDrive:" "%h/OneDrive"'';
        ExecStop = "/bin/fusermount -u %h/OneDrive/%i";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
