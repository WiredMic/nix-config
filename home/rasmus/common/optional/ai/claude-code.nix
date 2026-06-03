{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.claude-code.enable = lib.mkEnableOption "enables claude-code";
  };

  config = lib.mkIf config.my.claude-code.enable {

    programs.claude-code.enable = true;

    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
    };

  };
}
