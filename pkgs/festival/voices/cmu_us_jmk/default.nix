{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_jmk";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_jmk_cg.tar.gz";
    hash = "sha256-cR2ziLxQAzHP2oakanIZPKHiydx9XvFt/IaCfkmZRvI=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_jmk";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
