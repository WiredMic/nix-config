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
    my.zsh.enable = lib.mkEnableOption "enables my zsh config";
  };

  config = lib.mkIf config.my.zsh.enable {
    # https://search.nixos.org/options?channel=24.05&show=programs.zsh.enable&from=0&size=50&sort=relevance&type=packages&query=zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

  };
}
