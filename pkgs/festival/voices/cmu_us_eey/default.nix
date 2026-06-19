{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_eey";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_eey_cg.tar.gz";
    hash = "sha256-r4WQ98G6fV26Iv9Swwp7s/VVkuq8qWFc1xL6Taj4PhM=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_eey";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
