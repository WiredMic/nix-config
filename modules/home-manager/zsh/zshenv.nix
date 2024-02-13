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
  
  # Environment Variables to always set at login

  home.sessionVariables = {
    EDITOR = "nvim";

    # gnupg as ssh-agent
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";

    # flatpak
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };

  # Environment Variables in the .zshenv file
  programs.zsh = {
    initExtra = ''
    gpg-connect-agent updatestartuptty /bye > /dev/null # help pgp find user tty for password prompts
    '';
    sessionVariables = {
      # flatpak

      COWPATH = "$XDG_DATA_HOME/cowsay/";
    };

    envExtra = ''
    '';
  };
}
