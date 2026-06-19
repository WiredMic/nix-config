{
  lib,
  stdenv,
  festival,
}:

{
  pname,
  version,
  src,
  meta ? { },
  ...
}@attrs:

stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r lib "$out/lib"

    runHook postInstall
  '';

  passthru.isFestivalVoice = true;

  meta = {
    platforms = lib.platforms.all;
  }
  // meta;
}
