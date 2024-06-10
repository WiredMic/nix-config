# sddm theme
{
  pkgs,
  # qtgraphicaleffects,
  ...
}:

let
  imgLink = "https://i.pinimg.com/originals/b8/22/c2/b822c207cb1faf95895729cea939f59a.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-KQd/aKfpYMInX0kHIyc8OLFxAkHbmyYYvHeHGGIgT4s=";
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.9.1";
  dontBuild = true;
  src = pkgs.fetchFromGitHub {
    owner = "stepanzubkov";
    repo = "where-is-my-sddm-theme";
    rev = "bdde61b875bcf7321d00b38049cb564250cb0a8c";
    hash = "sha256-kgsVY2hK3OOwaAsFboIg8fRAQwFBpLEDhQ2Nu2xxDD0=";
  };

  # propagatedUserEnvPkgs = [
  #   qtgraphicaleffects
  # ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/where-is-my-sddm-theme-tree
    cp -R $src/where_is_my_sddm_theme/. $out/share/sddm/themes/where-is-my-sddm-theme-tree
    cd $out/share/sddm/themes/where-is-my-sddm-theme-tree
    rm theme.conf
    cp -r ${image} Background.png
    cp ${./where-is-my-sddm-theme-tree.conf} ./theme.conf
    # cp ./example_configs/tree.png ./Background.png
   '';
}
