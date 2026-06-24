{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "kal_diphone";
  pname = "festvox-kal-diphone";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_kallpc16k.tar.gz";
    hash = "sha256-gJxKte2eTfSmWLWNXFb+NQVXI/ANgaI4Fo9aHr2u0Iw=";
  };

  meta = with lib; {
    description = "Festival English (US) voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
