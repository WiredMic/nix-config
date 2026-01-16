{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}:
let
  kurzgesagt_dyson_sphere = pkgs.callPackage ./background/kurzgesagt_dyson_sphere.nix { };
in
{
  options = {
    my.stylix.enable = lib.mkEnableOption "enables stylix to style tilling managers";
  };

  config = lib.mkIf config.my.stylix.enable {
    # Ricing Linux Has Never Been Easier | NixOS + Stylix
    # https://www.youtube.com/watch?v=ljHkWgBaQWU&t=9s
    environment.systemPackages = with pkgs; [
      base16-schemes
      papirus-icon-theme
      kurzgesagt_dyson_sphere
    ];

    stylix = {
      enable = true;
      autoEnable = true;
    };

    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    # Don't forget to apply wallpaper
    stylix.image = lib.mkForce "${kurzgesagt_dyson_sphere}/kurzgesagt_dyson_sphere.png";

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${userSettings.style-color}.yaml";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };

    stylix.fonts.sizes = {
      applications = 12;
      terminal = 14;
      desktop = 10;
      popups = 10;
    };

    stylix.opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    stylix.polarity = "dark"; # "light" or "either"
  };
}
