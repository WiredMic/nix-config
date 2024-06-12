{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    # sddm
    ./sddm/sddm-icon.nix
    
    # dev
    ./dev/dev-env.nix
    ./dev/neovim/neovim.nix
    ./dev/emacs/emacs.nix
  ];
  
  my.sddm-icon.enable = lib.mkDefault true;

  my.direnv.enable = lib.mkDefault false;
}
