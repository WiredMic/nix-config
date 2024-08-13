 {
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
  # Here everything in the core dir is imported.
  ./zsh.nix
  ];

  # Because this is the core dir everything is enabled by default
  # If this is not the case move the config to optional
  
  my.zsh.enable = lib.mkDefault true;

}
