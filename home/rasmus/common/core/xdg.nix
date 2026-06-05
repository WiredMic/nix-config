{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.xdg.enable = lib.mkEnableOption "enables my XDG config";
  };

  config = lib.mkIf config.my.xdg.enable {
    xdg = {
      enable = true;

      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";
      binHome = "${config.xdg.dataHome}/bin";

      userDirs = {
        enable = true;
        package = pkgs.xdg-user-dirs;
        createDirectories = true;

        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        projects = "${config.home.homeDirectory}/Projects";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/Templates";
        videos = "${config.home.homeDirectory}/Videos";

      };
    };
  };
}
