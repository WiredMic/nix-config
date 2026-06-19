{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_guj_kt";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_guj_kt_cg.tar.gz";
    hash = "sha256-ZmAX2NZHN8T9cLcqts+Eb9jhPeKQpbpJS9Fpckmhbp0=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_guj_kt";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
