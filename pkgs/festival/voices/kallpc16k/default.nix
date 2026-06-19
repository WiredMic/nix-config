{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "kallpc16k";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_kallpc16k.tar.gz";
    hash = "sha256-gJxKte2eTfSmWLWNXFb+NQVXI/ANgaI4Fo9aHr2u0Iw=";  
  };

  meta = with lib; {
    description = "Festival voice: kallpc16k";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
