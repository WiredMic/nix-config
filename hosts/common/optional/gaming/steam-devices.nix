{
  pkgs ? import <nixpkgs> { }
}:

pkgs.stdenv.mkDerivation {
  name = "steam-devices";
  src = pkgs.fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "steam-devices";
    rev = "e2971e45063f6b327ccedbf18e168bda6749155c";
    hash = "sha256-kBqWw3TlCSWS7gJXgza2ghemypQ0AEg7NhWqAFnal04=";
  };
  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp -R ./*.rules $out/etc/udev/rules.d/.
   '';
}
