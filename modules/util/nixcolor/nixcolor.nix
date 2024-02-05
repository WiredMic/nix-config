{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    
    
    ./featues/kitty.nix
  ];

  # This is the link to all the style guides
  # https://github.com/chriskempson/base16
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}

