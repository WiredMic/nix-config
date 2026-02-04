{
  config,
  lib,
  pkgs,
  ...
}:

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
            "/dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd"
            "/dev/input/by-id/usb-AONE_Varmilo_Keyboard-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
                caps h j k l lctl )

            (defvar
                tap-time 150
                hold-time 200 )

            (defalias
            caps (tap-hold $tap-time $hold-time esc lctl)
            lctl (layer-while-held arrows)
            )


            (deflayer base
            @caps _ _ _ _ @lctl
            )
            (deflayer arrows
            @caps left down up right lctl
            )

          '';
        };
      };
    };

  };
}
