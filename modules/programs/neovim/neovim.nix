{
  pkgs,
  config,
  fetchFromGitHub,
  ...
}:
{
  programs.neovim.enable = true;

  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
  owner = "NvChad";
  repo = "NvChad";
  rev = "f17e83010f25784b58dea175c6480b3a8225a3e9";
  hash = "sha256-P5TRjg603/7kOVNFC8nXfyciNRLsIeFvKsoRCIwFP3I=";
  };

  # xdg.configFile."nvim/lua/custom/".source = ./my_nvchad_config;
  # xdg.configFile."nvim/lua/custom/".recursive = true;
}
