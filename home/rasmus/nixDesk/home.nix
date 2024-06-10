{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: 
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # Core
    ../common/core/core.nix

    # Optional
    ../common/optional/optional.nix

    # zsh
    ../../../modules/home-manager/zsh/zsh.nix
    
    # Color scheme
    # ../../../modules/home-manager/util/nixcolor/nixcolor.nix
    
    # GnuPG
    ../../../modules/home-manager/gnupg/gnupg.nix
    
    # Neovim
    ../../../modules/home-manager/neovim/neovim.nix
    
    # SDDM avatar
    # ../../../modules/programs/sddm/sddm-icon.nix
     
    # System Theme QT and GTK
    # ../../../modules/home-manager/util/theme/theme.nix
  ];

  
  home = {
    username = "rasmus";
    homeDirectory = "/home/rasmus";
  };
    
  home.packages = (with pkgs; [
    stow
    flatpak
    vlc
    gnome.gnome-software
    neofetch
    pass
    nurl
    rustup
    unzip
    gimp
    gnome.gnome-calculator
    gnome-multi-writer

    # fetchFromGithub

    # Libra office and spell check
    libreoffice-qt
    hunspell
    hunspellDicts.da_DK

    # LaTeX
    # texlive.combined.scheme-full

    gparted
  ])
  ++
  (with pkgs-unstable; [
    # eza
  ]);

  # Devops
  my.direnv.enable = true; 

  xdg.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userEmail = "rasmus@enev.dk";
    userName = "Rasmus Enevoldsen";
    # git config --global init.defaultBranch
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;
    extraConfig = ''
    AddKeysToAgent yes
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
