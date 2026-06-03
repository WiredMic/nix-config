{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.git.enable = lib.mkEnableOption "enables my git config";
  };

  config = lib.mkIf config.my.git.enable {
    home.packages = with pkgs; [ lazygit ];
    programs.git = {
      enable = true;
      settings = {
        user = {
          Email = "rasmus@enev.dk";
          Name = "Rasmus Enevoldsen";
        };
        init.defaultBranch = "trunk";
        aliases = {
          tree = "log --graph --oneline --all";
        };
        pull.rebase = "true";
        core = {
          editor = "${config.home.sessionVariables.EDITOR}";
        };
      };
    };
  };
}
