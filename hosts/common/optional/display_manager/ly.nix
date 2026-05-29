{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ];

  options = {
    my.ly.enable = lib.mkEnableOption "enables Ly config";
  };

  config = lib.mkIf config.my.ly.enable {
    environment.systemPackages = with pkgs; [
    ];

    services.displayManager.ly = {
      enable = true;
      package = pkgs.ly;
      x11Support = false;
      settings = {
        numlock = true;
        animation = "gameoflife";
        gameoflife_frame_delay = 3;
      };
    };
  };
}
