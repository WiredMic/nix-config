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
    ./git.nix
    ./mime.nix
    ./xdg.nix
  ];

  my.ssh.enable = lib.mkDefault true;
  my.gpg.enable = lib.mkForce true;
  my.git.enable = lib.mkDefault true;
  my.mime.enable = lib.mkDefault true;
  my.xdg.enable = lib.mkDefault true;

}
