{ config, lib, pkgs, ... }:

# find in $HOME/.local/state/nix/profiles/home-manager-55-link/home-path/share/texmf/tex/latex/
let
  latex-mysty = pkgs.stdenvNoCC.mkDerivation {
    name = "latex-mysty";
    src = ./mysty2;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/tex/latex/mysty2
      cp -r $src/. $out/tex/latex/mysty2
    '';
    passthru.tlType = "run";
  };

  texlive-mysty = { pkgs = [ latex-mysty ]; };

  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full;
    inherit texlive-mysty;
  };
in {
  imports = [ ];

  options = { my.latex.enable = lib.mkEnableOption "enables latex"; };

  config = lib.mkIf config.my.rust.enable {

    home.packages = with pkgs; [ tex zathura ];

  };
}
