{
  pkgs,
  config,
  ...
}:
{
  programs.zsh.profileExtra = ''
    export PASSWORD_STORE_DIR = "XDG_DATA_HOME"/pass
  ''; 

  home.sessionPath = [
    "\${xdg.configHome}/cargo/bin"
  ];
}
