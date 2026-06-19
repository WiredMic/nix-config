{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_rxr";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_rxr_cg.tar.gz";
    hash = "sha256-vzYrbycLGkx2vpgcPovYYvuxemTpceW0qE2XDtXs7EI=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_rxr";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
