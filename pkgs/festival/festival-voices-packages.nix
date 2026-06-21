{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  newScope,
  festival,
  mbrola,
  mbrola-voices,
}:

lib.makeScope newScope (self: {

  buildFestivalVoice = self.callPackage ./build-festival-voice.nix {
    inherit lib stdenv;
  };

  buildFestivalMbrolaVoiceWrapper = self.callPackage ./build-festival-mbrola-voice-wrapper.nix {
    inherit
      lib
      stdenv
      mbrola-voices
      mbrola
      ;
  };

  # US English voices (CMU)
  cmu_us_aew = self.callPackage ./voices/cmu_us_aew { };
  cmu_us_ahw = self.callPackage ./voices/cmu_us_ahw { };
  cmu_us_aup = self.callPackage ./voices/cmu_us_aup { };
  cmu_us_awb = self.callPackage ./voicess/cmu_us_awb { };
  cmu_us_axb = self.callPackage ./voices/cmu_us_axb { };
  cmu_us_bdl = self.callPackage ./voices/cmu_us_bdl { };
  cmu_us_clb = self.callPackage ./voices/cmu_us_clb { };
  cmu_us_eey = self.callPackage ./voices/cmu_us_eey { };
  cmu_us_fem = self.callPackage ./voices/cmu_us_fem { };
  cmu_us_gka = self.callPackage ./voices/cmu_us_gka { };
  cmu_us_jmk = self.callPackage ./voices/cmu_us_jmk { };
  cmu_us_ksp = self.callPackage ./voices/cmu_us_ksp { };
  cmu_us_ljm = self.callPackage ./voices/cmu_us_ljm { };
  cmu_us_lnh = self.callPackage ./voices/cmu_us_lnh { };
  cmu_us_rms = self.callPackage ./voices/cmu_us_rms { };
  cmu_us_rxr = self.callPackage ./voices/cmu_us_rxr { };
  cmu_us_slp = self.callPackage ./voices/cmu_us_slp { };
  cmu_us_slt = self.callPackage ./voices/cmu_us_slt { };
  us1_mbrola = self.callPackage ./voices/us1_mbrola { };
  us2_mbrola = self.callPackage ./voices/us2_mbrola { };
  us3_mbrola = self.callPackage ./voices/us3_mbrola { };

  # Indian
  cmu_indic_ben_rm = self.callPackage ./voices/cmu_indic_ben_rm { };
  cmu_indic_guj_ad = self.callPackage ./voices/cmu_indic_guj_ad { };
  cmu_indic_guj_dp = self.callPackage ./voices/cmu_indic_guj_dp { };
  cmu_indic_guj_kt = self.callPackage ./voices/cmu_indic_guj_kt { };
  cmu_indic_hin_ab = self.callPackage ./voices/cmu_indic_hin_ab { };
  cmu_indic_kan_plv = self.callPackage ./voices/cmu_indic_kan_plv { };
  cmu_indic_mar_aup = self.callPackage ./voices/cmu_indic_mar_aup { };
  cmu_indic_mar_slp = self.callPackage ./voices/cmu_indic_mar_slp { };
  cmu_indic_pan_amp = self.callPackage ./voices/cmu_indic_pan_amp { };
  cmu_indic_tam_sdr = self.callPackage ./voices/cmu_indic_tam_sdr { };
  cmu_indic_tel_kpn = self.callPackage ./voices/cmu_indic_tel_kpn { };
  cmu_indic_tel_sk = self.callPackage ./voices/cmu_indic_tel_sk { };
  cmu_indic_tel_ss = self.callPackage ./voices/cmu_indic_tel_ss { };

  # British
  kallpc16k = self.callPackage ./voices/kallpc16k { };
  rablpc16k = self.callPackage ./voices/rablpc16k { };
  en1_mbrola = self.callPackage ./voices/en1_mbrola { };

})
