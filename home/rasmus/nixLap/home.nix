{ inputs, outputs, lib, config, pkgs, pkgs-unstable, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Core
    ../common/core/core.nix

    # Optional
    ../common/optional/optional.nix

    # Per PC configurations
    ./de/de-optional.nix
  ];

  home = {
    username = "rasmus";
    homeDirectory = "/home/rasmus";
  };

  home.sessionVariables = {
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv"; # Nvidia path
    HISTFILE = "${config.xdg.stateHome}/bash/history";

    # XORG
    ERRFILE = "${config.xdg.cacheHome}/X11/xsession-errors";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";

    GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # Temp Env Var
    GSK_RENDERER = "gl";
  };

  nix.settings.use-xdg-base-directories = true; # moves .nix-* out of HOME

  home.packages = (with pkgs; [
    xdg-ninja

    flatpak
    vlc
    neofetch
    pass
    nurl

    zip
    unzip

    gnome-calculator
    gnome-multi-writer
    tldr
    libation # audible libaretor
    pavucontrol

    btop # system monitor

    # Libra office and spell check
    libreoffice-qt
    hunspell
    hunspellDicts.da_DK
    hunspellDicts.en-us

    localsend

    ranger

    # file manager
    xfce.thunar

    (rWrapper.override {
      packages = with rPackages; [
        languageserver # LSP
        lintr
      ];
    })
  ]) ++ (with pkgs-unstable;
    [
      # eza
    ]);

  programs.kitty.enable = true;

  # Theme
  my.theme.enable = true;

  # Devops
  my.direnv.enable = true;
  my.emacs.enable = true;
  my.neovim.enable = true;
  my.rust.enable = true;
  my.latex.enable = true;
  my.octave.enable = true;

  # ssh 
  my.ssh.enable = true;
  my.gpg.enable = true;

  # password manager 
  my.pass.enable = true;

  # Zsh
  my.cowsay-shell-script.enable = true;

  xdg.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
