{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.mime.enable = lib.mkEnableOption "enables my extentiens to work";
  };

  config = lib.mkIf config.my.mime.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/pdf" = "org.kde.okular.desktop";
      };
    };
  };
}
