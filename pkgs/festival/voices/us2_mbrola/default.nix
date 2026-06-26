{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
}:
buildFestivalVoice (finalAttrs: {
  voiceName = "us2_mbrola";
  mbrolaVoiceName = "us2";
  pname = "festvox-us2-mbrola";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.mbrolaVoiceName}.tar.gz";
    hash = "sha256-0nrSYhMUTZVoFegEwG5UcxkawSr7RPahAps4QuOjAHw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r lib "$out/lib"

    ln -s "${
      mbrola-voices.override { languages = [ finalAttrs.mbrolaVoiceName ]; }
    }/data/${finalAttrs.mbrolaVoiceName}"         "$out/lib/voices/english/${finalAttrs.voiceName}/${finalAttrs.mbrolaVoiceName}"

    runHook postInstall
  '';

  passthru.extraBinPath = [ mbrola ];

  meta = with lib; {
    description = "Festival MBROLA English (US) voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
