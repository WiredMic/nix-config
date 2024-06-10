{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
  ];
 
  options = {
    de.cosmic.enable = 
      lib.mkEnableOption "enables cosmic config";
  };

  config = lib.mkIf config.de.cosmic.enable {
  
  };
}
