{
  config,
  lib,
  pkgs,
  ...
}:

{

  options = {
    my.opencode.enable = lib.mkEnableOption "Enables OpenCode";
  };

  config = lib.mkIf config.my.opencode.enable {

    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
    };

  };
}
