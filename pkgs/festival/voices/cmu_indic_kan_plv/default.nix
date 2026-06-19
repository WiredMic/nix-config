{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_kan_plv";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_kan_plv_cg.tar.gz";
    hash = "sha256-2H9Oo0LnyzfpDd9J3eN/GcFHCzxaCdAM7zISEIEHyzE=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_kan_plv";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
