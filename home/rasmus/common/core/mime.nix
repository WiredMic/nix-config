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
      defaultApplications =
        let
          gwenview = "org.kde.gwenview.desktop";
        in
        lib.genAttrs [
          "image/jpeg"
          "image/png"
          "image/gif"
          "image/webp"
          "image/tiff"
          "image/bmp"
          "image/svg+xml"
          "image/avif"
          "image/heic"
        ] (_: gwenview)
        // {
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "application/pdf" = "org.kde.okular.desktop";
          "text/plain" = "emacsclient.desktop";
        };
    };
  };
}
