{
  lib,
  fetchurl,
  buildFestivalMbrolaVoiceWrapper,
  ...
}:

buildFestivalMbrolaVoiceWrapper (finalAttrs: {
  voiceName = "us3";
  pname = "festvox-mbrola-${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/${finalAttrs.version}/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-r5yk0YMuGXGqblL2o/+Pcpv5cMe+4d5+isBhHKAYcbg=";
  };

  meta = with lib; {
    description = "Festival MBROLA voice ${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
