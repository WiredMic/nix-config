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
    de.gnome.enable = 
      lib.mkEnableOption "enables gnome config";
  };

  config = lib.mkIf config.de.gnome.enable {
    # https://nixos.wiki/wiki/GNOME
    # https://search.nixos.org/options?channel=24.05&from=0&size=50&sort=relevance&type=packages&query=gnome
    services.xserver = {
      enable = true;
      # displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
 

}

