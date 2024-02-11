# https://github.com/vinceliuice/grub2-themes
{pkgs,...}:
pkgs.stdenv.mkDerivation {
  name = "grub2-themes";
  src = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "grub2-themes";
    rev = "000171da277b8d0219f90782708d42c700081a44";
    hash = "sha256-KYwOOYAWsFNM5EGdauew5HOVj9HdWWGcjGy7mLX+V6w=";
  };
  installPhase = ''
    ./install.sh -t tela -i color -s 1080p
   '';
}


