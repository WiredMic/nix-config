{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_pan_amp";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_pan_amp_cg.tar.gz";
    hash = "sha256-8ekjjGuGRqKiUquFX1dzyOvfiz35CeC75Kmde4MKTz4=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_pan_amp";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
