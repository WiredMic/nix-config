{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_bdl";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_bdl_cg.tar.gz";
    hash = "sha256-HcZ5KvniwWYKRv5JmqZ69K/6ZloL3AggfMEXGbqmL20=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_bdl";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
