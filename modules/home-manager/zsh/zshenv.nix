{ config, lib, pkgs, ...}:
{
  imports = [
  ../gnupg/gnupg.nix
  ];
  
  # XDG
  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config/";
    dataHome = "${config.home.homeDirectory}/.local/share/";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };
  
  # Environment Variables in the .zshenv file
  programs.zsh.envExtra = ''
      export COWPATH="$XDG_DATA_HOME/cowsay/"

      # flatpak
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share

      # export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

      # gnupg as ssh-agent
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)" # set SSH_AUTH_SOCK
      gpg-connect-agent updatestartuptty /bye > /dev/null # help pgp find user tty for password prompts


    '';
}
