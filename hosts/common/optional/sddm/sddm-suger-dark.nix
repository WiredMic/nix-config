# sddm theme 
# does not work for kde6
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
  pname = "sddm-suger-dark";
  version = "1.2";
  dontBuild = true;
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "sha256-flOspjpYezPvGZ6b4R/Mr18N7N3JdytCSwwu6mf4owQ=";
  };

  # propagatedUserEnvPkgs = [
  #   qtgraphicaleffects
  # ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/sddm-sugar-dark
    cp -R $src/* $out/share/sddm/themes/sddm-sugar-dark
    cd $out/share/sddm/themes/sddm-sugar-dark
    rm Background.jpg
    cp -r ${image} Background.jpg
   '';
}
