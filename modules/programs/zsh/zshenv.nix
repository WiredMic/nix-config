{ config, lib, pkgs, ...}:
{
  imports = [];
  
  # Environment Variables in the .zshenv file
  program.zsh.envExtra = ''
      export COWPATH="$XDG_DATA_HOME/cowsay/"
    '';
}
