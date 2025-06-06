{ pkgs, ... }:

let
  imgLink =
    "https://drive.google.com/uc?export=download&id=1RbxlvMczjc2zhwiTcqvZ7p17u_jU6gLz";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-LnftjASNvElhE43U/42/2BNQ8bk5yVQIc2kY6m8YCJ4=";
  };
in pkgs.stdenv.mkDerivation rec {
  pname = "kurzgesagt_dyson_sphere";
  version = "1";
  dontBuild = true;
  src = image;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp $src $out/kurzgesagt_dyson_sphere.png
  '';
}
