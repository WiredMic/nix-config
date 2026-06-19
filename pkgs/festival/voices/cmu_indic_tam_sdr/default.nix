{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_tam_sdr";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_tam_sdr_cg.tar.gz";
    hash = "sha256-mkwIjOO9vxeGfV35GPw4aFlwYTgK6Nr4ls6Z0zcj5XA=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_tam_sdr";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
