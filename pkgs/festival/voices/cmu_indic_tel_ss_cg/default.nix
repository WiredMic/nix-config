{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "cmu_indic_tel_ss_cg";
  pname = "festvox-cmu-indic-tel-ss-cg";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${finalAttrs.version}/voices/festvox_${finalAttrs.voiceName}.tar.gz";
    hash = "sha256-suVspHIuPQJdgx/R7vZ5/78A/hZbaKRKVZYyFBH/ofA=";
  };

  meta = with lib; {
    description = "Festival Telugu voice ${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
