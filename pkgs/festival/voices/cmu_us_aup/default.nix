{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_us_aup";
  pname = "festvox-cmu-us-aup";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-RVR24cUkbZCqwJCgavpaTpDIAa66zm/jV5AMjglb6CY=";
  };

  meta = with lib; {
    description = "Festival voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
