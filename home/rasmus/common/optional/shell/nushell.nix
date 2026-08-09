{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    my.nushell.enable = lib.mkEnableOption "enables nushell config";
  };

  config = lib.mkIf config.my.nushell.enable {

    home.packages = with pkgs; [
      ripgrep
      fd
    ];

    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

      # Manual lines in .zshrc file
      initContent = ''
        if [[ $- == *i* ]] && [[ -z "$NU_VERSION" ]]; then
          exec ${config.programs.nushell.package}/bin/nu
        fi
      '';
    };

    programs.nushell = {
      enable = true;
      # https://github.com/nix-community/home-manager/pull/9666
      environmentVariables = config.home.sessionVariables // {
        XDG_DATA_DIRS = lib.concatStringsSep ":" config.xdg.systemDirs.data;
        XDG_CONFIG_DIRS = lib.concatStringsSep ":" config.xdg.systemDirs.config;
      };
      envFile.text = ''
        $env.config.edit_mode = 'vi'
      '';
    };

    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        git_status = {
          ahead = "⇡";
          stashed = "\\$";
          deleted = "✘";
          renamed = "»";
          staged = "+";
        };
      };
      presets = [
        "nerd-font-symbols"
      ];
    };

    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [ ];
    };
  };
}
