{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_aew";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_aew_cg.tar.gz";
    hash = "sha256-XZVVWAuVMk+nNLd3HJXc7UTnkDUQNYSB0k5P5clhERw=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_aew";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
