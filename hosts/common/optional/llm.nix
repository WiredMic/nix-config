{ config, lib, pkgs, ... }:

{

  options = {
    my.ollama.enable = lib.mkEnableOption "Enables LLM's through Ollama";
  };

  config = lib.mkIf config.my.ollama.enable {
    # LLM
    services.ollama = {
      enable = true;
      acceleration = null;
      loadModels = [ "deepseek-r1:14b" "deepseek-coder-v2:16b" ];
      openFirewall = false;
      port = 11434;
    };

    services.open-webui = {
      enable = true;
      openFirewall = false;
      port = 11111;
      environment = {
        OLLAMA_API_BASE_URL =
          "http://127.0.0.1:${toString config.services.ollama.port}";
        # Disable authentication
        WEBUI_AUTH = "False";
      };

    };
  };
}
