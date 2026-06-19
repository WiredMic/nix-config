{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_guj_dp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_guj_dp_cg.tar.gz";
    hash = "sha256-Gk4X1n21Cm2B94YLZKzI1BJF9vdjzP9Mk4armumSORA=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_guj_dp";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
