{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    
    # Templates
    # https://github.com/chriskempson/base16-templates-source?tab=readme-ov-file
    ./features/kitty.nix
  ];

  # This is the link to all the style guides
  # https://github.com/chriskempson/base16
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}

