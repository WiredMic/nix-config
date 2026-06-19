{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_slt";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_slt_cg.tar.gz";
    hash = "sha256-eMuT42GrAW/SODPFaFPd8h4vE1YxD1Tu0cCal1XOn0M=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_slt";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
