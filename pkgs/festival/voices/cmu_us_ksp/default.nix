{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_ksp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_ksp_cg.tar.gz";
    hash = "sha256-O4CYrDCZXOJF1RjFuP7oJZF0KMs+vgQJoLQVyRm9018=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_ksp";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
