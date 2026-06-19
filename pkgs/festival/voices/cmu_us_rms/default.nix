{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_rms";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_rms_cg.tar.gz";
    hash = "sha256-MWevo6b/tbvDBclKHmtnHkB4Ooekk3L84ExUlChyxCE=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_rms";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
