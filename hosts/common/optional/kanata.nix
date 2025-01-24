{ config, lib, pkgs, ... }:

{

  options = {
    my.kanata.enable = lib.mkEnableOption "Enables kanata as keyboard manager";
  };

  config = lib.mkIf config.my.kanata.enable {
    environment.systemPackages = with pkgs; [ kanata ];

    services.kanata = {
      enable = true;
      package = pkgs.kanata;
      keyboards = {
        laptop = {
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            # "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-event-kbd"
            # "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-if02-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
             caps a s d f j k l ;
            )
            (defvar
             tap-time 150
             hold-time 200
            )
            (defalias
             caps (tap-hold 150 200 esc lctl)
             a (tap-hold $tap-time $hold-time a lmet)
             s (tap-hold $tap-time $hold-time s lalt)
             d (tap-hold $tap-time $hold-time d lsft)
             f (tap-hold $tap-time $hold-time f lctl)
             j (tap-hold $tap-time $hold-time j rctl)
             k (tap-hold $tap-time $hold-time k rsft)
             l (tap-hold $tap-time $hold-time l ralt)
             ; (tap-hold $tap-time $hold-time ; rmet)
            )

            (deflayer base
             @caps @a  @s  @d  @f  @j  @k  @l  @;
            )
          '';
        };
      };
    };

  };
}
