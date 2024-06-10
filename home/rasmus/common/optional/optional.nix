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
  ];
  
  my.sddm-icon.enable = lib.mkDefault true;

  my.direnv.enable = lib.mkDefault false;
}
