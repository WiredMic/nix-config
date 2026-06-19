{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  newScope,
  festival,
}:

lib.makeScope newScope (self: {

  buildFestivalVoice = self.callPackage ./build-festival-voice.nix {
    inherit lib stdenv festival;
  };

  # US English voices (CMU)
  cmu_us_awb = self.callPackage ./voices/cmu_us_awb { };
  # cmu_us_bdl = self.callPackage ./voices/cmu_us_bdl { };
  # cmu_us_clb = self.callPackage ./voices/cmu_us_clb { };
  # cmu_us_jmk = self.callPackage ./voices/cmu_us_jmk { };
  # cmu_us_rms = self.callPackage ./voices/cmu_us_rms { };
  # cmu_us_slt = self.callPackage ./voices/cmu_us_slt { };

  # # British English voices
  # rab_diphone = self.callPackage ./voices/rab_diphone { };
  # ked_diphone = self.callPackage ./voices/ked_diphone { };
  # don_diphone = self.callPackage ./voices/don_diphone { };

  # # Spanish voices
  # el_diphone = self.callPackage ./voices/el_diphone { };
})
