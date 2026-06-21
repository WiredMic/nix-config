{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_us_ljm";
  pname = "festvox-cmu-us-ljm";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-rsBiw9DDBxndfj6e5MQny6rV5HVQ4ory6fFRpB3K2FI=";
  };

  meta = with lib; {
    description = "Festival voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
