{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_ljm";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_ljm_cg.tar.gz";
    hash = "sha256-rsBiw9DDBxndfj6e5MQny6rV5HVQ4ory6fFRpB3K2FI=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_ljm";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
