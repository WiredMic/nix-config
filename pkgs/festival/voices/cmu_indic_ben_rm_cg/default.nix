{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_ben_rm_cg";
  pname = "festvox-cmu-indic-ben-rm-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-VuIUTV7tbImkUXie9/NzRt01Hv27hqD6ZQQyoZsHNn8=";
  };

  meta = with lib; {
    description = "Festival Bengali voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
