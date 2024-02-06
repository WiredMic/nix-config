{
  pkgs,
  config,
  cfg,
  ...
}:
{
  programs.gpg = {
    enable = true;
    settings = {
    };
    homedir = "${config.xdg.configHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
 
  programs.zsh.envExtra = ''
    export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
  '';
}
