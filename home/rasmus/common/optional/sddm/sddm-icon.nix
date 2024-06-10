{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.sddm-icon.enable = 
      lib.mkEnableOption "enables sddm icon config";
  };
  # set icon
  # It cannot be read by sddm. 
  # I have copied the icon into /var/lib/AccountsService/icons/ as the name of the user "rasmus".
  # This is not optimal
  
  config = lib.mkIf config.my.sddm-icon.enable {
    home.file.".face.icon".source = ./rasmus.face.png;
    home.file.".face".source = ./rasmus.face.png;
  };
}

