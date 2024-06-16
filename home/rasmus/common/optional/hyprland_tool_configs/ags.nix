{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];
  options = { my.ags.enable = lib.mkEnableOption "enables my ags config"; };

  config = {
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = ./ags;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [ gtksourceview webkitgtk accountsservice ];

    };
    # xdg.configFile."ags" = {
    #   enable = true;
    #   recursive = true;
    #   source = lib.mkForce ./ags;
    # };

  };
}
