{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_ben_rm";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_ben_rm_cg.tar.gz";
    hash = "sha256-VuIUTV7tbImkUXie9/NzRt01Hv27hqD6ZQQyoZsHNn8=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_ben_rm";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
