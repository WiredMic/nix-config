{ config, lib, pkgs, userSettings, ... }: {
  imports = [ ];

  # XDG
  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config/";
    dataHome = "${config.home.homeDirectory}/.local/share/";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Environment Variables to always set at login

  home.sessionVariables = {
    # flatpak
    XDG_DATA_DIRS =
      "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };

  home.sessionVariables = {
    EDITOR = "${userSettings.editor}";
    VISUAL = "$EDITOR";
  };
}
