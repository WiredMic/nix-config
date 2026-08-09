{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Here everything in the core dir is imported.
    ./shell.nix
    ./scripts.nix
  ];

  # Because this is the core dir everything is enabled by default
  # If this is not the case move the config to optional

  my.shell.enable = lib.mkDefault true;

}
