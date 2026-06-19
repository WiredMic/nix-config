{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_clb";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_clb_cg.tar.gz";
    hash = "sha256-EcgtHBjOPbb7Ecp4jMXYT2n5NGr/d8dJX1AAXWsEIUg=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_clb";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
