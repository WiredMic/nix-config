{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_mar_aup";
  pname = "festvox-cmu-indic-mar-aup";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-DHUJIDSD/JfAS2cBJ7IMLVFyOzoWUXEk4i0JXzecyn8=";
  };

  meta = with lib; {
    description = "Festival Marathi voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
