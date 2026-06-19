{
  config,
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice {
  pname = "festvox_cmu_us_awb";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/2.5/voices/festvox_cmu_us_awb_cg.tar.gz";
    hash = "sha256-sq29/toMuiibtNpo3RQRTT6z5/cgScyNLL37LfOfaTQ=";
  };
  meta = {

  };
}
