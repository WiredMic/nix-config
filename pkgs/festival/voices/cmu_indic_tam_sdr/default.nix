{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_tam_sdr";
  pname = "festvox-cmu-indic-tam-sdr";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}_cg.tar.gz";
    hash = "sha256-mkwIjOO9vxeGfV35GPw4aFlwYTgK6Nr4ls6Z0zcj5XA=";
  };

  meta = with lib; {
    description = "Festival Tamil voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
