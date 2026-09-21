{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.platformio.enable = lib.mkEnableOption "Enables platformio";
  };

  config = lib.mkIf config.my.platformio.enable {
    environment.systemPackages = with pkgs; [
      platformio
    ];

    services.udev.packages = with pkgs; [ platformio-core.udev ];
  };
}
