{ pkgs, config, ... }: {
  programs.zsh.profileExtra = ''
    source ${config.xdg.stateHome}/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh
  '';
  home.sessionPath = [ "${config.xdg.configHome}/test/bin" ];
}
