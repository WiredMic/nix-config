{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
  ];
  
  options = {
    my.hyprland.enable =
      lib.mkEnableOption "enables my hyprland config";
  };

  config = lib.mkIf config.my.hyprland.enable {
    home.packages = with pkgs; [
      wtype
      
    ];
    
    xdg.configFile."hypr" = {
      enable = true;
      source = ./hyprland;
      recursive = true;
    };
  };

}
