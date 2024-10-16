{ pkgs, lib, config, userSettings, ... }: {
  imports = [
    # de 
    ./de/hyprland/hyprland-home.nix

    # hyprland tools
    # ./hyprland_tool_configs/tofi.nix
    ./hyprland_tool_configs/ags.nix

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

    # Clouds
    ./onedrive.nix

  ];

  my.hyprland.enable = lib.mkForce userSettings.de.hyprland;

  # my.tofi.enable = lib.mkForce userSettings.de.hyprland;
  my.ags.enable = lib.mkForce userSettings.de.hyprland;

  my.sddm-icon.enable = lib.mkDefault true;

  my.theme.enable = lib.mkDefault false;

  my.direnv.enable = lib.mkDefault false;
  my.emacs.enable = lib.mkDefault false;
  my.neovim.enable = lib.mkDefault false;
  my.rust.enable = lib.mkDefault false;
  my.latex.enable = lib.mkDefault false;

  my.pass.enable = lib.mkDefault false;

  my.cowsay-shell-script.enable = lib.mkDefault false;

  my.onedrive.enable = lib.mkDefault false;
}
