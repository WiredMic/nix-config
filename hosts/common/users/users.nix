 {
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
  # Here every user is imported.
  ./rasmus.nix
  ];

  user.rasmus.enable = lib.mkDefault true;

}
