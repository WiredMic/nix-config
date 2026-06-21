{
  lib,
  fetchurl,
  buildFestivalMbrolaVoiceWrapper,
  ...
}:

buildFestivalMbrolaVoiceWrapper (finalAttrs: {
  voiceName = "en1";
  pname = "festvox-mbrola-${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-pLtV056u8x62rYuRUDXDEQiyQnEIUS4cMBlB+/j2/7k=";
  };

  meta = with lib; {
    description = "Festival MBROLA voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
