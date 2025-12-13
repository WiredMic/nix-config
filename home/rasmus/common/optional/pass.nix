{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.pass.enable = lib.mkEnableOption "enables pass the password manager";
  };

  config = lib.mkIf config.my.pass.enable {
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      };
    };
    home.packages = with pkgs; [
      passff-host
      pass-git-helper
    ];

    programs.git = {
      settings = {
        credential = {
          helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
        };
      };
    };

    # Create the pass-git-helper mapping configuration
    xdg.configFile."pass-git-helper/git-pass-mapping.ini".text = ''
      [git.overleaf.com*]
      target=overleaf/school
      username_extractor=regex_search
      regex_username=^username: (.*)$
      password_extractor=regex_search
      regex_password=^git token: (.*)$
    '';

  };
}
