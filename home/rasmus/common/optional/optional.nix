{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    # de 
    ./de/hyprland/hyprland-home.nix

    # sddm
    ./sddm/sddm-icon.nix
    
    # dev
    ./dev/dev-env.nix
    ./dev/neovim/neovim.nix
    ./dev/emacs/emacs.nix
    ./dev/rust.nix

    ./pass.nix

    # ../../../../hosts/common/optional/optional.nix
  ];
  
  # config = lib.mkIf de.hyprland.enable {
    my.hyprland.enable = lib.mkDefault false;
  # };

  my.sddm-icon.enable = lib.mkDefault true;

  my.direnv.enable = lib.mkDefault false;
  my.emacs.enable = lib.mkDefault false;
  my.rust.enable = lib.mkDefault false;

  my.pass.enable = lib.mkDefault false;
}
