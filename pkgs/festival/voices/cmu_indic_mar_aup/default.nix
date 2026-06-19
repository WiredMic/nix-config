{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_mar_aup";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_mar_aup_cg.tar.gz";
    hash = "sha256-DHUJIDSD/JfAS2cBJ7IMLVFyOzoWUXEk4i0JXzecyn8=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_mar_aup";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
