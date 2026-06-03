{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ./ollama-load-models.nix
  ];

  options = {
    my.ollama.enable = lib.mkEnableOption "Enables LLM's through Ollama";
  };

  config = lib.mkIf config.my.ollama.enable {
    # # LLM
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      loadModels = [
        "deepseek-r1:14b"
        "qwen3-coder:30b"
        # "deepseek-coder-v2:16b"
      ];
      syncModels = true;
      port = 11434;
    };

    # services.open-webui = {
    #   enable = true;
    #   openFirewall = false;
    #   port = 11111;
    #   environment = {
    #     OLLAMA_API_BASE_URL =
    #       "http://127.0.0.1:${toString config.services.ollama.port}";
    #     # Disable authentication
    #     WEBUI_AUTH = "False";
    #   };

    # };
  };
}
