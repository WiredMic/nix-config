{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "upc_ca_eli_hts";
  pname = "upc-ca-eli-hts";
  version = "1.3";

  src = fetchurl {
    url = "https://festcat.talp.cat/download//${finalAttrs.voiceName}-${finalAttrs.version}.tgz";
    hash = "sha256-g04p9doi63+gQPuR8aWEo76hSsS8acMqu3A43rXoXJc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/voices/catalan/${finalAttrs.voiceName}"
    for d in festvox hts; do
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
