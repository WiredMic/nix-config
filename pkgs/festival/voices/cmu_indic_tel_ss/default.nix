{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_tel_ss";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_tel_ss_cg.tar.gz";
    hash = "sha256-suVspHIuPQJdgx/R7vZ5/78A/hZbaKRKVZYyFBH/ofA=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_tel_ss";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
