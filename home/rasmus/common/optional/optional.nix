{
  pkgs,
  lib,
  config,
  userSettings,
  ...
}:
{
  imports = [
    # de
    ./de/hyprland/hyprland.nix
    ./de/cosmic/cosmic.nix
    ./de/kde/kde.nix

    # sddm
    ./sddm/sddm-icon.nix

    # Theme
    ./theme.nix

    # dev
    ./dev/devenv.nix
    ./dev/neovim/neovim.nix
    ./dev/emacs/emacs.nix
    ./dev/vscode.nix
    ./dev/rust.nix
    ./dev/latex/latex.nix

    ./pass.nix

    ./cowsay/cowsay.nix

    ./octave/octave.nix

    ./kitty.nix

    # cloud
    ./cloud/syncthing.nix

    # llm
    ./ai/claude-code.nix
    ./ai/ollama.nix
    ./ai/opencode.nix
  ];

  xdg.portal.enable = lib.mkForce false;
  my.cosmic.enable = lib.mkDefault userSettings.de.cosmic;
  my.common.hyprland.enable = lib.mkDefault userSettings.de.hyprland;
  my.kde.enable = lib.mkDefault userSettings.de.kde;

  my.sddm-icon.enable = lib.mkDefault true;

  my.theme.enable = lib.mkDefault false;

  my.direnv.enable = lib.mkDefault false;
  my.emacs.enable = lib.mkDefault false;
  my.neovim.enable = lib.mkDefault false;
  my.vscode.enable = lib.mkDefault false;
  my.rust.enable = lib.mkDefault false;
  my.latex.enable = lib.mkDefault false;

  my.pass.enable = lib.mkDefault false;
  my.kitty.enable = lib.mkDefault false;

  my.cowsay-shell-script.enable = lib.mkDefault false;

  my.octave.enable = lib.mkDefault false;

  # cloud
  my.syncthing.enable = lib.mkDefault false;

  # AI
  my.ollama.enable = lib.mkDefault false;
  my.opencode.enable = lib.mkDefault false;
}
