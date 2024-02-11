# sddm theme
{pkgs,...}:

let
  imgLink = "https://i.pinimg.com/originals/b8/22/c2/b822c207cb1faf95895729cea939f59a.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-KQd/aKfpYMInX0kHIyc8OLFxAkHbmyYYvHeHGGIgT4s=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
   '';
}
