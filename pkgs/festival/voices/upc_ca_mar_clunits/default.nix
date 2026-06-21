{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "upc_ca_mar_clunits";
  pname = "upc-ca-mar-clunits";
  version = "1.2";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-EBbhZex8D4+ClyXTivFTEHoqH4al0Sauqy4dOc8RQEk=";
  };


  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.voiceName}"
    for d in doc festival festvox mcep wav; do
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
