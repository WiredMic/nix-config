{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "upc_ca_pol_clunits";
  pname = "upc-ca-pol-clunits";
  version = "1.2";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-uSUSerdRYwV4nqEC0GcSrxE+UZ1U05/Uwgu1+RDwRFA=";
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
