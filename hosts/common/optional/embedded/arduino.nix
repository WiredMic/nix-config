{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ];

  options = {
    my.arduino.enable = lib.mkEnableOption "Enables arduino";
  };

  config = lib.mkIf config.my.arduino.enable {
    environment.systemPackages = with pkgs; [
      arduino-ide
      arduino-cli
      (python3.withPackages (p: with p; [ pyserial ]))
    ];

    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "arduino-udev-rules";
        text = ''
          ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", TAG+="uaccess"
          ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", TAG+="uaccess"
          ACTION!="remove", KERNEL=="ttyACM*", ATTRS{idVendor}=="2341", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/60-arduino.rules";
      })
    ];
  };
}
