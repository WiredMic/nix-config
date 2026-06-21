{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_us_axb";
  pname = "festvox-cmu-us-axb";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-FyyCbfnI9J7LA/mXdJsgeiPehnjc8TcGcJEEwsWX6/s=";
  };

  meta = with lib; {
    description = "Festival voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
