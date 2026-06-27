# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
final: prev: {
  scadformat = final.callPackage ./scadformat/package.nix { };

  piper-tts = final.callPackage ./piper-tts/package.nix { };

  # Should user be able to install a voice on their own
  speech-tools = final.callPackage ./speech-tools/package.nix { };

  upc_ca_base = final.callPackage ./upc_ca_base/package.nix { };
  festival-czech = final.callPackage ./festival-czech/package.nix { };

  festival =
    (final.callPackage ./festival/package.nix {
      inherit (final) speech-tools;
      inherit (final) ncurses alsa-lib;
    }).overrideAttrs
      (old: {
        passthru = old.passthru // {
          tests = final.lib.mapAttrs (_: pkg: pkg.passthru.tests.synthesizes) final.festival.packages;
        };
      });
  # Should user be able to install a voice on their own
  # festivalVoices = final.lib.recurseIntoAttrs final.festival.packages;

  festivalVoiceTests = final.symlinkJoin {
    name = "festival-voice-tests";
    paths = final.lib.mapAttrsToList (_: pkg: pkg.passthru.tests.synthesizes) (
      final.lib.filterAttrs (_: final.lib.isDerivation) final.festival.packages
    );
  };

  festivalFull = final.festival.withSiteInitConfig (
    voices: with voices; [
      cmu_us_aew_cg
      cmu_us_ahw_cg
      cmu_us_aup_cg
      cmu_us_axb_cg
      cmu_us_bdl_cg
      cmu_us_clb_cg
      cmu_us_eey_cg
      cmu_us_fem_cg
      cmu_us_gka_cg
      cmu_us_jmk_cg
      cmu_us_ksp_cg
      cmu_us_ljm_cg
      cmu_us_lnh_cg
      cmu_us_rms_cg
      cmu_us_rxr_cg
      cmu_us_slp_cg
      cmu_us_slt_cg
      cmu_indic_ben_rm_cg
      cmu_indic_guj_ad_cg
      cmu_indic_guj_dp_cg
      cmu_indic_guj_kt_cg
      cmu_indic_hin_ab_cg
      cmu_indic_kan_plv_cg
      cmu_indic_mar_aup_cg
      cmu_indic_mar_slp_cg
      cmu_indic_pan_amp_cg
      cmu_indic_tam_sdr_cg
      cmu_indic_tel_kpn_cg
      cmu_indic_tel_sk_cg
      cmu_indic_tel_ss_cg
      kal_diphone
      rab_diphone
      us1_mbrola
      us2_mbrola
      us3_mbrola
      en1_mbrola
      upc_ca_bet_hts
      upc_ca_eli_hts
      upc_ca_eva_hts
      upc_ca_jan_hts
      upc_ca_mar_hts
      upc_ca_ona_hts
      upc_ca_pau_hts
      upc_ca_pep_hts
      upc_ca_pol_hts
      upc_ca_teo_hts
      upc_ca_uri_hts
      upc_ca_pep_clunits
      upc_ca_bet_clunits
      upc_ca_teo_clunits
      upc_ca_uri_clunits
      upc_ca_ona_clunits
      upc_ca_pau_clunits
      upc_ca_eli_clunits
      upc_ca_eva_clunits
      upc_ca_mar_clunits
      upc_ca_jan_clunits
      upc_ca_pol_clunits
      # czech_mbrola_cz1
      czech_mbrola_cz2
    ]
  ) { defaultVoice = "kal_diphone"; };

  festivalMbrola = final.festival.withSiteInitConfig (
    voices: with voices; [
      us1_mbrola
      us2_mbrola
      us3_mbrola
      en1_mbrola
    ]
  ) { defaultVoice = "us1_mbrola"; };

  festivalCatalan = final.festival.withSiteInitConfig (
    voices: with voices; [
      upc_ca_bet_hts
      upc_ca_eli_hts
      upc_ca_eva_hts
      upc_ca_jan_hts
      upc_ca_mar_hts
      upc_ca_ona_hts
      upc_ca_pau_hts
      upc_ca_pep_hts
      upc_ca_pol_hts
      upc_ca_teo_hts
      upc_ca_uri_hts
      upc_ca_pep_clunits
      upc_ca_bet_clunits
      upc_ca_teo_clunits
      upc_ca_uri_clunits
      upc_ca_ona_clunits
      upc_ca_pau_clunits
      upc_ca_eli_clunits
      upc_ca_eva_clunits
      upc_ca_mar_clunits
      upc_ca_jan_clunits
      upc_ca_pol_clunits
    ]
  ) { defaultVoice = "upc_ca_bet_hts"; };

}
