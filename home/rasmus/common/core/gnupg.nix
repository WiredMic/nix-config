{ pkgs, config, lib, ... }: {
  options = { my.gpg.enable = lib.mkEnableOption "enables my gpg config"; };

  config = lib.mkIf config.my.gpg.enable {
    programs.gpg = {
      enable = true;
      settings = { };
      homedir = "${config.xdg.configHome}/gnupg";
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-tty;
    };

    home.sessionVariables = {
      # gnupg as ssh-agent
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
