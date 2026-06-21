{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_guj_dp";
  pname = "festvox-cmu-indic-guj-dp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-Gk4X1n21Cm2B94YLZKzI1BJF9vdjzP9Mk4armumSORA=";
  };

  meta = with lib; {
    description = "Festival voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
