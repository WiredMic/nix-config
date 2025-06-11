{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.theme.enable = lib.mkEnableOption "enables theme config";
  };

  config = lib.mkIf config.my.theme.enable {
    home.packages = with pkgs; [ papirus-icon-theme ];

    # I use Stylix to set theme
    qt.enable = true;

    # Stylix cannot set icon theme
    gtk = {
      enable = true;

      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

  };
}
