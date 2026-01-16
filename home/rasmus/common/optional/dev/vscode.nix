{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ];

  options = {
    my.vscode.enable = lib.mkEnableOption "enables VSCode";
  };

  config = lib.mkIf config.my.rust.enable {

    home.packages = with pkgs; [ ];

    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        myriad-dreamin.tinymist
        mkhl.direnv
      ];
      mutableExtensionsDir = true;
    };

  };
}
