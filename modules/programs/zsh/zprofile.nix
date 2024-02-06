{
  pkgs,
  config,
  ...
}:
{
  programs.zsh.profileExtra = ''
  export PASSWORD_STORE_DIR = "XDG_DATA_HOME"/pass
  PATH = "XDG_DATA_HOME/cargo/bin:$PATH"
  '';
}
