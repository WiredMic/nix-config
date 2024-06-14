{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.git.enable =
      lib.mkEnableOption "enables my git config";
  };

  config = lib.mkIf config.my.git.enable {

    programs.git = {
      enable = true;
      userEmail = "rasmus@enev.dk";
      userName = "Rasmus Enevoldsen";
      # git config --global init.defaultBranch
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
