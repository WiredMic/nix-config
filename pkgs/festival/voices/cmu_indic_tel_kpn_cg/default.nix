{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_tel_kpn_cg";
  pname = "festvox-cmu-indic-tel-kpn-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-Q61wCoKicFMN2kT9SomzRCnDdyPN3hMPrs5IEXI/9ys=";
  };

  meta = with lib; {
    description = "Festival Telugu voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
