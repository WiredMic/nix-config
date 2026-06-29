{ pkgs, lib, ... }:
{
  settings = {
    formatter = {
      keep-sorted = {
        command = lib.getExe pkgs.keep-sorted;
        includes = [ "*" ];
      };
    };
  };

  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.nixfmt = {
    enable = true;
    package = pkgs.nixfmt;
    indent = 2;
  };
}
