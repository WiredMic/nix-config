{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
  ];

  options = {
    de.kde.enable = 
      lib.mkEnableOption "enables kde config";
  };

  config = lib.mkIf config.de.kde.enable {
    # KDE
    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";
  };
}
