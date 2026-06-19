{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_lnh";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_lnh_cg.tar.gz";
    hash = "sha256-7OgfQjef66TDkq1yP7aDdK/5zXj1fPYp9iSwvQySjQg=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_lnh";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
