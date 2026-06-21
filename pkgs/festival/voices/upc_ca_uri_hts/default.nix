{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "upc_ca_uri_hts";
  pname = "upc-ca-uri-hts";
  version = "1.3";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-oRnBd9O/j+C35BG9nrzscEDvjigRuUoSVVK/bmRxuZI=";
  };


  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.voiceName}"
    for d in festvox hts; do
      [ -d "$d" ] && cp -r "$d" "$out/lib/voices/catalan/${finalAttrs.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.festivalDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
