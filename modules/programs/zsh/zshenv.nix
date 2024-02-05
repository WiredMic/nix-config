{ config, lib, pkgs, ...}:
{
  imports = [];
  
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
    '';
}
