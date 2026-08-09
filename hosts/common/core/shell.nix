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
    my.shell.enable = lib.mkEnableOption "enables my shell config";
  };

  config = lib.mkIf config.my.shell.enable {
    environment.systemPackages = [
      pkgs.nushell
    ];
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
