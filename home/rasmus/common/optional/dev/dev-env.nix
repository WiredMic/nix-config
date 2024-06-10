{ 
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
  ];

  options = {
    my.direnv.enable =
      lib.mkEnableOption "enables direnv";
  };

  config = lib.mkIf config.my.direnv.enable {
  # use direnv to manage different nix shells
  # https://www.youtube.com/watch?v=WJZgzwB3ziE&t=500s
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    # https://github.com/nix-community/nix-direnv
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
  ];
  };
}
