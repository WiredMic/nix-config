{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_indic_tel_kpn";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_indic_tel_kpn_cg.tar.gz";
    hash = "sha256-Q61wCoKicFMN2kT9SomzRCnDdyPN3hMPrs5IEXI/9ys=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_indic_tel_kpn";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
