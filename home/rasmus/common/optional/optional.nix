{ pkgs, lib, config, userSettings, ... }: {
  imports = [
    # de 
    ./de/hyprland/hyprland-home.nix

    # hyprland tools
    # ./hyprland_tool_configs/tofi.nix
    ./hyprland_tool_configs/ags.nix

    # sddm
    ./sddm/sddm-icon.nix

    # dev
    ./dev/dev-env.nix
    ./dev/neovim/neovim.nix
    ./dev/emacs/emacs.nix
    ./dev/rust.nix

    ./pass.nix

  ];

  my.hyprland.enable = lib.mkForce userSettings.de.hyprland;

  # my.tofi.enable = lib.mkForce userSettings.de.hyprland;
  my.ags.enable = lib.mkForce userSettings.de.hyprland;

  my.sddm-icon.enable = lib.mkDefault true;

  my.direnv.enable = lib.mkDefault false;
  my.emacs.enable = lib.mkDefault false;
  my.rust.enable = lib.mkDefault false;

  my.pass.enable = lib.mkDefault false;
}
