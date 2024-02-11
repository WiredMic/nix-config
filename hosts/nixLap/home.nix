# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
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


    # zsh
    ../../modules/home-manager/zsh/zsh.nix
    
    # Color scheme
    ../../modules/home-manager/util/nixcolor/nixcolor.nix
    
    # GnuPG
    ../../modules/home-manager/gnupg/gnupg.nix
    
    # Neovim
    ../../modules/home-manager/neovim/neovim.nix
    
    # SDDM avatar
    ../../modules/programs/sddm/sddm-icon.nix
     
    # System Theme QT and GTK
    ../../modules/home-manager/util/theme/theme.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

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

    # fetchFromGithub

    # Libra office and spell check
    libreoffice-qt
    hunspell
    hunspellDicts.da_DK

    # LaTeX
    texlive.combined.scheme-full
  ])
  ++
  (with pkgs-unstable; [
    # eza
  ]);


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
  home.stateVersion = "23.05";
}
