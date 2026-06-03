{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
  ];

  options = {
    my.ssh.enable = lib.mkEnableOption "enables my ssh config";
  };

  config = lib.mkIf config.my.ssh.enable {
    # https://search.nixos.org/options?channel=24.05&show=programs.zsh.enable&from=0&size=50&sort=relevance&type=packages&query=zsh
    # multiple github accounts
    # https://www.youtube.com/watch?v=jGwD3e1BZ5Y
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          compression = true;
          forwardAgent = true;
          addKeysToAgent = "yes";
        };
        "github.com" = {
          host = "github.com";
          hostname = "github.com";
          identityFile = "~/.ssh/github";
          PreferredAuthentications = "publickey";
        };
        "invent.kde.org" = {
          host = "invent.kde.org";
          hostname = "invent.kde.org";
          identityFile = "~/.ssh/invent.kde.org";
          PreferredAuthentications = "publickey";
        };

      };
    };

    services.ssh-agent = lib.mkIf (!config.services.gpg-agent.enableSshSupport) {
      enable = true;
      package = pkgs.openssh;
      enableZshIntegration = config.programs.zsh.enable;
    };

  };
}
