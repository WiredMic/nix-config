{ pkgs, lib, config, userSettings, ... }: {
  imports = [
    # de 
    ./de/hyprland/hyprland.nix

    # sddm
    ./sddm/sddm-icon.nix

    # Theme
    ./theme.nix

    # dev
    ./dev/devenv.nix
    ./dev/neovim/neovim.nix
    ./dev/emacs/emacs.nix
    ./dev/rust.nix
    ./dev/latex/latex.nix

    ./pass.nix

    ./cowsay/cowsay.nix

    ./octave/octave.nix
  ];

  my.common.hyprland.enable = lib.mkForce userSettings.de.hyprland;
  # my.common.hyprland.enable = false;

  my.sddm-icon.enable = lib.mkDefault true;

  my.theme.enable = lib.mkDefault false;

  my.direnv.enable = lib.mkDefault false;
  my.emacs.enable = lib.mkDefault false;
  my.neovim.enable = lib.mkDefault false;
  my.rust.enable = lib.mkDefault false;
  my.latex.enable = lib.mkDefault false;

  my.pass.enable = lib.mkDefault false;

  my.cowsay-shell-script.enable = lib.mkDefault false;

  my.octave.enable = lib.mkDefault false;
}
