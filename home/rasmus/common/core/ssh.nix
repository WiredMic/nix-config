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
    my.ssh.enable = 
      lib.mkEnableOption "enables my ssh config";
  };

  config = lib.mkIf config.my.ssh.enable {
  # https://search.nixos.org/options?channel=24.05&show=programs.zsh.enable&from=0&size=50&sort=relevance&type=packages&query=zsh
  # multiple github accounts 
  # https://www.youtube.com/watch?v=jGwD3e1BZ5Y
  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;
    addKeysToAgent = "yes";

    matchBlocks."github.com" = {
      host = "github.com";
      hostname = "github.com";
      identityFile = "~/.ssh/github";
      extraOptions = {
         PreferredAuthentications = "publickey";
      };
    };
  };
  };
}
