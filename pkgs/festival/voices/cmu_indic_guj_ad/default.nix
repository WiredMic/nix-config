{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_guj_ad";
  pname = "festvox-cmu-indic-guj-ad";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-SgrC0bFc1BEIvoA+I/EZEb6VO1BzOEio5nQoxkLgK6k=";
  };

  meta = with lib; {
    description = "Festival voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
