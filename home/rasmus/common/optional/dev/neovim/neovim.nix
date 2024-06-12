{
  pkgs,
  config,
  fetchFromGitHub,
  ...
}:
{
  # https://www.reddit.com/r/NixOS/comments/13uc87h/masonnvim_broke_on_nixos/
  programs.neovim.enable = true;


  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile."nvim".source = pkgs.stdenv.mkDerivation {
    name = "NvChad";
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "f17e83010f25784b58dea175c6480b3a8225a3e9";
      hash = "sha256-P5TRjg603/7kOVNFC8nXfyciNRLsIeFvKsoRCIwFP3I=";
    };
    installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
    cd $out/
    cp -r ${./my_nvchad_config} $out/lua/custom
    '';
  };

  # xdg.configFile."nvim/lua/custom/".source = ./my_nvchad_config;
  # xdg.configFile."nvim/lua/custom/".recursive = true;
}
