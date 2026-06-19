{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_slp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_slp_cg.tar.gz";
    hash = "sha256-8djmAcljHft/i9BcNB2fzoiZ3JVH7ZplLI3tarhU3po=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_slp";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
