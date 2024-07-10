{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.pass.enable = 
      lib.mkEnableOption "enables pass the password manager";
  };

  config = lib.mkIf config.my.pass.enable {
    programs.password-store = {
      enable = true;
      settings = { PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store"; };
    };
    home.packages = with pkgs; [
      passff-host
    ];

  };
}
