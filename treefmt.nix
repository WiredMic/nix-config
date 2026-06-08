{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.nixfmt = {
    enable = true;
    package = pkgs.nixfmt;
    indent = 2;
  };
}
