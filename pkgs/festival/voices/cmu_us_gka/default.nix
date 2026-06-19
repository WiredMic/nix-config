{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_gka";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_gka_cg.tar.gz";
    hash = "sha256-R88hqWrfytOYvSi00lSEk6IFX3XlPPcTRO7zrrwDq1k=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_gka";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
