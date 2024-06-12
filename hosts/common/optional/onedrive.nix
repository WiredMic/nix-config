{
  pkgs, 
  lib,
  config,
  ...
}:
{
  imports = [];
 
  options = {
    my.onedrive.enable = 
      lib.mkEnableOption "enables the ability to configure onedrive";
  };

  config = lib.mkIf config.my.onedrive.enable {
    # https://nixos.wiki/wiki/OneDrive
    services.onedrive.enable = true;
    # rclone
    # https://www.youtube.com/watch?v=u_W0-HEVOyg
  };

}
