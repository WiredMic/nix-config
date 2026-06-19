{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_aup";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_aup_cg.tar.gz";
    hash = "sha256-RVR24cUkbZCqwJCgavpaTpDIAa66zm/jV5AMjglb6CY=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_aup";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
