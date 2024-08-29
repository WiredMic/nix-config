{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = { my.arduino.enable = lib.mkEnableOption "Enables arduino"; };

  config = lib.mkIf config.my.arduino.enable {
    environment.systemPackages = with pkgs; [
      arduino-ide
      arduino-cli
      (python312.withPackages (p: with p; [ pyserial ]))
    ];
    # system.activationScripts.script.text = "chmod 666 /dev/ttyACM0";

    # https://wiki.archlinux.org/title/Udev
    services.udev.extraRules = ''
      KERNEL=="ttyACM0", MODE:="666"
    '';
  };
}
