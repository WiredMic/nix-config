{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_ahw";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_ahw_cg.tar.gz";
    hash = "sha256-kGSSR4vYa1IB9y/+cBJ5uYs7qUrnSBag1/K6ILwrW/c=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_ahw";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
