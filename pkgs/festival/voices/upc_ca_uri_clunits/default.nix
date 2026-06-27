{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "upc_ca_uri_clunits";
  pname = "upc-ca-uri-clunits";
  version = "1.2";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-qX6P/eQ3+62m30fBTmD77JE8PrjoN37E1dvyfk3sTgQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.voiceName}"
    for d in doc festival festvox mcep wav; do
      [ -d "$d" ] && cp -r "$d" "$out/lib/voices/catalan/${finalAttrs.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.extraLibDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice ${finalAttrs.voiceName}";
    homepage = "https://festcat.talp.cat";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
