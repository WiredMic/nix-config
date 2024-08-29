{ pkgs, lib, config, ... }: {
  imports = [ ./ssh.nix ./gnupg.nix ./zsh/zsh.nix ./git.nix ];

  my.ssh.enable = lib.mkDefault true;
  my.gpg.enable = lib.mkForce true;
  my.git.enable = lib.mkDefault true;

}
