{
  lib,
  fetchurl,
  buildFestivalMbrolaVoiceWrapper,
  ...
}:

buildFestivalMbrolaVoiceWrapper (finalAttrs: {
  voiceName = "us1";
  pname = "festvox-mbrola-${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-I7MyUThn1unDQNyIinzmeEPlo8A9syjNNpdZhQV8i44=";
  };

  meta = with lib; {
    description = "Festival MBROLA voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
