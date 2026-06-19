{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "cmu_us_axb";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_axb_cg.tar.gz";
    hash = "sha256-FyyCbfnI9J7LA/mXdJsgeiPehnjc8TcGcJEEwsWX6/s=";  
  };

  meta = with lib; {
    description = "Festival voice: cmu_us_axb";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
