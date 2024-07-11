{
  pkgs,
  config,
  ...
}:
{
  programs.zsh.initExtra = ''
    source $XDG_STATE_HOME/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh
  '';
  home.sessionPath = [
    "${config.xdg.configHome}/test/bin"
  ];
  }
