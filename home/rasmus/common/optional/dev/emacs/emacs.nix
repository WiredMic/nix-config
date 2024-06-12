{
  pkgs,
  lib,
  config,
  xdg,
  ...
}:
{
  # home.packages = with pkgs; [
  #   emacs
  # ];

  programs.emacs.enable = true;

  # if I install Doom Emacs with nix it cannot manage it self.
  # Therefoe these commands should be run outside of nix.
  # git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  # ~/.config/emacs/bin/doom install

  # does not work
  # home.sessionPath = [
  #   "\${xdg.configHome}/emacs/bin/"
  # ];
  
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    jetbrains-mono
    fira
  ];

  systemd.user.sessionVariables = {
    PATH = "\${xdg.configHome}/emacs/bin/:$PATH";
  };

  xdg.configFile."doom" = {
    enable = true;
    source = ./doom-emacs;
    recursive = true;
    target = "doom";
  };
}
