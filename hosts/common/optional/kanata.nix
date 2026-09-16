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
