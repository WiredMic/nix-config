{ pkgs, lib, config, ... }: {
  options = { my.git.enable = lib.mkEnableOption "enables my git config"; };

  config = lib.mkIf config.my.git.enable {
    home.packages = with pkgs; [ lazygit ];
    programs.git = {
      enable = true;
      userEmail = "rasmus@enev.dk";
      userName = "Rasmus Enevoldsen";
      # git config --global init.defaultBranch
      aliases = { tree = "log --graph --oneline --all"; };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "true";
        core = { editor = "${config.home.sessionVariables.EDITOR}"; };
      };
    };
  };
}

