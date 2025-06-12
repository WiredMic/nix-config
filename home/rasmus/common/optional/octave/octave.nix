{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [ ];

  options = {
    my.octave.enable = lib.mkEnableOption "enables octave and other packages";
  };

  config = lib.mkIf config.my.octave.enable {

    home.packages = with pkgs-unstable; [
      (octave.withPackages (
        opkgs: with opkgs; [
          symbolic
          quaternion
          signal
          control
        ]
      ))
      ghostscript
    ];

    home.sessionVariables = {
      OCTAVE_HISTFILE = "${config.xdg.cacheHome}/octave-hsts";
      OCTAVE_SITE_INITFILE = "${config.xdg.configHome}/octave/octaverc";
    };

    xdg.configFile."octave/octaverc".text = ''
      #source /usr/share/octave/site/m/startup/octaverc;
      # pkg prefix ~/.local/share/octave/packages ~/.local/share/octave/packages;
      # pkg local_list ${config.home.homeDirectory}/.local/share/octave/octave_packages;
    '';
  };
}
