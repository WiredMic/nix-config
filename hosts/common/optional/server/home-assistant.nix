{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.home-assistant.enable = lib.mkEnableOption "enables home-assistant";
  };

  config = lib.mkIf config.my.home-assistant.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      extraComponents = [
        # Components required to complete the onboarding
        "default_config"
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"
        "matter"
        "thread"
        "cast"
        "androidtv_remote"
        "upnp"
        "wiz"
        "heos"
        "denonavr"

      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        http.server_port = 8123;
      };
    };
  };
}
