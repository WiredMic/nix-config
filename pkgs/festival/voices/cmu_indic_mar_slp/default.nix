{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_mar_slp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_mar_slp_cg.tar.gz";
    hash = "sha256-875yQdNdseGNZS4s+ky2m64DjD0hxZ7TzjZUh4lPDUY=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_mar_slp";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
