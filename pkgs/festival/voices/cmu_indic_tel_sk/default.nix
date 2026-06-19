{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_tel_sk";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_tel_sk_cg.tar.gz";
    hash = "sha256-DuEC6Ak6VJFx9eT/gm6/P56vhOfUMll3fjjK/kxLbuo=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_tel_sk";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
