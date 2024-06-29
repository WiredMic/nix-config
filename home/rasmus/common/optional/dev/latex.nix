{ config, lib, pkgs, ... }:

{

  imports = [ ];

  options = { my.latex.enable = lib.mkEnableOption "enables latex"; };

  config = lib.mkIf config.my.rust.enable {

    home.packages = with pkgs; [ texliveFull zathura ];

  };
}
