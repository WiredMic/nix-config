{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./ssh.nix
    ./gnupg.nix
    ./zsh/zsh.nix

  ];
  
  my.ssh.enable = lib.mkDefault true;
  my.gpg.enable = lib.mkForce true;
  
}
