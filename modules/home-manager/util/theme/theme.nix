{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}:
{

  # qt theming does not work, so I am building my own around kvantum.
  
  home.packages = with pkgs-unstable; [
    libsForQt5.qt5ct 
    qt6Packages.qt6ct
    libsForQt5.qtstyleplugin-kvantum 
    qt6Packages.qtstyleplugin-kvantum
  ];

  qt = {
    enable = true;

    # platformTheme = "qtct";

    # style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };

  programs.zsh.envExtra = ''
  QT_STYLE_OVERRIDE=kvantum
  '';


  xdg.configFile."Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid".source = pkgs.stdenv.mkDerivation {
    name = "Utterly-Nord-Solid-Plasma";
    src = pkgs.fetchFromGitHub {
      owner = "HimDek";
      repo = "Utterly-Nord-Plasma";
      rev = "4ec5c8743f68b544ee227995616dec0624eff0e0";
      hash = "sha256-kJS7qkZd93Vc8/2w8LlSekSMEyobRfcYxrdajnNb38A=";
    };

    installPhase = ''
    mkdir -p $out
    cp -r ./kvantum-solid/* $out
    '';
  };
  # xdg.configFile."Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Utterly-Nord-Solid";

  gtk = {
    enable = true;
    
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.name = "adwaita-icon-theme";
  
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };


    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  
}
