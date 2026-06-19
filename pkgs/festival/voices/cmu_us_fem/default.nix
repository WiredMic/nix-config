{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_fem";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_fem_cg.tar.gz";
    hash = "sha256-+HiMKvSDi7kOCoWfONpmyVlhvf8lcgAdWgGaISfHQwY=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_fem";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
