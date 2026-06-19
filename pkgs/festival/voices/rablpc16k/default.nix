{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "rablpc16k";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_rablpc16k.tar.gz";
    hash = "sha256-7NFLd8Uo6U37B25EBQEC/o+6V+X+gTrPeKZmKTF/UqU=";  
  };

  meta = with lib; {
    description = "Festival voice: rablpc16k";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
