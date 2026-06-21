{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
}:
buildFestivalVoice (finalAttrs: {
  voiceName = "us2";
  pname = "festvox-mbrola-${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-0nrSYhMUTZVoFegEwG5UcxkawSr7RPahAps4QuOjAHw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r lib "$out/lib"

    ln -s "${
      mbrola-voices.override { languages = [ finalAttrs.voiceName ]; }
    }/data/${finalAttrs.voiceName}"       "$out/lib/voices/english/${finalAttrs.voiceName}_mbrola/${finalAttrs.voiceName}"

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
