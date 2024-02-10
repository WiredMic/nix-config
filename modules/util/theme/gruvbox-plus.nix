{pkgs,...}:
{
  pkgs.stdenv.mkDerivation {
    name = "gruvbox-plus";

    src = pkgs.fetchFromGitHub {
      owner = "SylEleuth";
      repo = "gruvbox-plus-icon-pack";
      rev = "078dc84efd4886bc516281f360a32c32a655e884";
      hash = "sha256-WIPIhzNConea40llcYIinYVwv36qrwWl8PYwF+ixttU=";
    };

    dontUnpack = true;

    installPhase = ''
    mkdir -p $out
    ${pkgs.unzip}/bin/unzip $src -d $out/
    '';
  };
}
