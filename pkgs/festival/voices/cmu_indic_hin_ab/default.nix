{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_hin_ab";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_hin_ab_cg.tar.gz";
    hash = "sha256-YDGOFg2ZTVF0FozJRGfHdt6BQm+RxPgAMgbP+VPLeb0=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_hin_ab";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
