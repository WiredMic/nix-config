{
  lib,
  fetchurl,
  buildFestivalMbrolaVoiceWrapper,
  ...
}:

buildFestivalMbrolaVoiceWrapper (finalAttrs: {
  voiceName = "us2";
  pname = "festvox-mbrola-${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-0nrSYhMUTZVoFegEwG5UcxkawSr7RPahAps4QuOjAHw=";
  };

  meta = with lib; {
    description = "Festival MBROLA voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
