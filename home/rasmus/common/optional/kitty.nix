{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.kitty.enable = lib.mkEnableOption "enables kitty";
  };

  config = lib.mkIf config.my.kitty.enable {

    programs.kitty = {
      enable = true;
      extraConfig = ''
        background_opacity         0.8
        dynamic_background_opacity yes
      '';
    };

  };
}
