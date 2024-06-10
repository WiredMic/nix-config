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
  
  my.sddm-icon.enable = lib.mkIf config.sddm.enable;

  my.direnv.enable = lib.mkDefault false;
}
