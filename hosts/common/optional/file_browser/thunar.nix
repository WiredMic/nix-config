{ config, lib, pkgs, ... }:

{

  options = {
    my.thunar.enable = lib.mkEnableOption "enables Thunar as file browser";
  };

  config = lib.mkIf config.my.thunar.enable {

    environment.systemPackages = [ pkgs.dconf ];

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin ];
    };

    programs.dconf.enable = true;

    environment.sessionVariables = rec { FILE_BROWSER = "thunar"; };
  };
}
