{
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kurzgesagt_dyson_sphere";
  version = "1.0.0";

  src = fetchurl {
    url = "https://drive.google.com/uc?export=download&id=1RbxlvMczjc2zhwiTcqvZ7p17u_jU6gLz";
    hash = "sha256-LnftjASNvElhE43U/42/2BNQ8bk5yVQIc2kY6m8YCJ4=";
  };

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp $src $out/kurzgesagt_dyson_sphere.png
  '';
})
