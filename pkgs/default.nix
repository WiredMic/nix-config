# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
final: prev: {
  scadformat = final.callPackage ./scadformat/package.nix { };
  festival = final.callPackage ./festival/package.nix {
    speech-tools = final.speech-tools;
  };
  # Should user be able to install a voice on their own
  # festivalVoices = final.lib.recurseIntoAttrs final.festival.packages;
  speech-tools = final.callPackage ./speech-tools/package.nix { };
  upc_ca_base = final.callPackage ./upc_ca_base/package.nix { };
  festivalFull = final.festival.withVoices (
    voices: with voices; [
      cmu_us_aew
      cmu_us_ahw
      cmu_us_aup
      cmu_us_axb
      cmu_us_bdl
      cmu_us_clb
      cmu_us_eey
      cmu_us_fem
      cmu_us_gka
      cmu_us_jmk
      cmu_us_ksp
      cmu_us_ljm
      cmu_us_lnh
      cmu_us_rms
      cmu_us_rxr
      cmu_us_slp
      cmu_us_slt
      cmu_indic_ben_rm
      cmu_indic_guj_ad
      cmu_indic_guj_dp
      cmu_indic_guj_kt
      cmu_indic_hin_ab
      cmu_indic_kan_plv
      cmu_indic_mar_aup
      cmu_indic_mar_slp
      cmu_indic_pan_amp
      cmu_indic_tam_sdr
      cmu_indic_tel_kpn
      cmu_indic_tel_sk
      cmu_indic_tel_ss
      kallpc16k
      rablpc16k
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
    ]
  );

  festivalMbrola = final.festival.withVoices (
    voices: with voices; [
      us1_mbrola
      us2_mbrola
      us3_mbrola
      en1_mbrola
    ]
  );
  festivalCatalan = final.festival.withVoices (
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
  );

}
