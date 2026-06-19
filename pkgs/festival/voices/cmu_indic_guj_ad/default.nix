{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_guj_ad";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_guj_ad_cg.tar.gz";
    hash = "sha256-SgrC0bFc1BEIvoA+I/EZEb6VO1BzOEio5nQoxkLgK6k=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_guj_ad";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
