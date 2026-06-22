#!/usr/bin/env bash
set -euo pipefail

declare -A festvox_voice_lang=(
    [cmu_us_aew]="English (US)"
    [cmu_us_ahw]="English (US)"
    [cmu_us_aup]="English (US)"
    [cmu_us_axb]="English (US)"
    [cmu_us_bdl]="English (US)"
    [cmu_us_clb]="English (US)"
    [cmu_us_eey]="English (US)"
    [cmu_us_fem]="English (US)"
    [cmu_us_gka]="English (US)"
    [cmu_us_jmk]="English (US)"
    [cmu_us_ksp]="English (US)"
    [cmu_us_ljm]="English (US)"
    [cmu_us_lnh]="English (US)"
    [cmu_us_rms]="English (US)"
    [cmu_us_rxr]="English (US)"
    [cmu_us_slp]="English (US)"
    [cmu_us_slt]="English (US)"
    [cmu_indic_ben_rm]="Bengali"
    [cmu_indic_guj_ad]="Gujarati"
    [cmu_indic_guj_dp]="Gujarati"
    [cmu_indic_guj_kt]="Gujarati"
    [cmu_indic_hin_ab]="Hindi"
    [cmu_indic_kan_plv]="Kannada"
    [cmu_indic_mar_aup]="Marathi"
    [cmu_indic_mar_slp]="Marathi"
    [cmu_indic_pan_amp]="Punjabi"
    [cmu_indic_tam_sdr]="Tamil"
    [cmu_indic_tel_kpn]="Telugu"
    [cmu_indic_tel_sk]="Telugu"
    [cmu_indic_tel_ss]="Telugu"
)

festvox_voices=("${!festvox_voice_lang[@]}")

declare -A festvox_voices_lang_special=(
    [kallpc16k]="English (US)"
    [rablpc16k]="English (GB)"
)

festvox_voices_special=("${!festvox_voices_lang_special[@]}")

declare -A mbrola_voice_lang=(
    [us1]="English (US)"
    [us2]="English (US)"
    [us3]="English (US)"
    [en1]="English (GB)"
)
mbrola_voices=("${!mbrola_voice_lang[@]}")

catalan_voice_hts=(
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
)
# https://festcat.talp.cat/download/upc_ca_uri_hts-1.3.tgz

catalan_voice_clunits=(
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
)
# https://festcat.talp.cat/download/upc_ca_pep_clunits-1.2.tgz

BASE_URL="http://festvox.org/packed/festival/2.5/voices"
BASE_WRAPPER_URL="https://www.cstr.ed.ac.uk/downloads/festival/1.95/"
BASE_URL_FESTCAT="https://festcat.talp.cat/download/"
CACHE_DIR="/tmp/festival-voices-cache"
mkdir -p "$CACHE_DIR"

rm -rf voices/*

for v in "${festvox_voices[@]}" "${festvox_voices_special[@]}" "${mbrola_voices[@]}" "${catalan_voice_hts[@]}" "${catalan_voice_clunits[@]}"; do

    if [[ " ${mbrola_voices[*]} " =~ " ${v} " ]]; then
        tarname="festvox_${v}.tar.gz"
        url="$BASE_WRAPPER_URL/$tarname"
        outdir="voices/${v}_mbrola"
        cg_suffix=""
        lang="${mbrola_voice_lang[$v]}"
    elif [[ " ${catalan_voice_hts[*]} " =~ " ${v} " ]]; then
        version="1.3"
        tarname="${v}-${version}.tgz"
        url="$BASE_URL_FESTCAT/$tarname"
        outdir="voices/$v"
        cg_suffix="-$version"
        lang="Catalan"
    elif [[ " ${catalan_voice_clunits[*]} " =~ " ${v} " ]]; then
        version="1.2"
        tarname="${v}-${version}.tgz"
        url="$BASE_URL_FESTCAT/$tarname"
        outdir="voices/$v"
        cg_suffix="-$version"
        lang="Catalan"
    elif [[ " ${festvox_voices_special[*]} " =~ " ${v} " ]]; then
        tarname="festvox_${v}.tar.gz"
        url="$BASE_URL/$tarname"
        outdir="voices/$v"
        cg_suffix=""
        lang="${festvox_voices_lang_special[$v]}"
    else
        tarname="festvox_${v}_cg.tar.gz"
        url="$BASE_URL/$tarname"
        outdir="voices/$v"
        cg_suffix="_cg"
        lang="${festvox_voice_lang[$v]}"
    fi

    mkdir -p "$outdir"
    cache_file="$CACHE_DIR/$tarname"

    if [[ ! -f "$cache_file" ]]; then
        echo "  ↓ Downloading $tarname ..."
        curl -L -s --fail -o "$cache_file" "$url" || {
            echo "  FAILED"
            continue
        }
    fi

    hash=$(nix hash file --type sha256 --sri "$cache_file")
    pname="festvox-$(echo "$v" | tr '_' '-')"

    if [[ " ${catalan_voice_hts[*]} " =~ " ${v} " ]]; then
        cat >"$outdir/default.nix" <<-EOF
{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "$v";
  pname = "$(echo "$v" | tr '_' '-')";
  version = "${version}";

  src = fetchurl {
    url = "${BASE_URL_FESTCAT}/\${finalAttrs.voiceName}-\${finalAttrs.version}.tgz";
    hash = "$hash";
  };


  installPhase = ''
    runHook preInstall

    mkdir -p "\$out/lib/voices/catalan/\${finalAttrs.voiceName}"
    for d in festvox hts; do
      [ -d "\$d" ] && cp -r "\$d" "\$out/lib/voices/catalan/\${finalAttrs.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.festivalDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice \${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
EOF
    elif [[ " ${catalan_voice_clunits[*]} " =~ " ${v} " ]]; then
        cat >"$outdir/default.nix" <<-EOF
{
  lib,
  fetchurl,
  buildFestivalVoice,
  upc_ca_base,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "$v";
  pname = "$(echo "$v" | tr '_' '-')";
  version = "${version}";

  src = fetchurl {
    url = "${BASE_URL_FESTCAT}/\${finalAttrs.voiceName}-\${finalAttrs.version}.tgz";
    hash = "$hash";
  };


  installPhase = ''
    runHook preInstall

    mkdir -p "\$out/lib/voices/catalan/\${finalAttrs.voiceName}"
    for d in doc festival festvox mcep wav; do
      [ -d "\$d" ] && cp -r "\$d" "\$out/lib/voices/catalan/\${finalAttrs.voiceName}/"
    done

    runHook postInstall
  '';

  passthru.festivalDeps = [ upc_ca_base ];

  meta = with lib; {
    description = "Festival Catalan voice \${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ WiredMic ];
  };
})
EOF

    elif [[ " ${mbrola_voices[*]} " =~ " ${v} " ]]; then
        cat >"$outdir/default.nix" <<-EOF
{
  lib,
  fetchurl,
  buildFestivalVoice,

  # Dependencies
  mbrola-voices,
  mbrola,
}:
buildFestivalVoice (finalAttrs: {
  voiceName = "$v";
  pname = "festvox-mbrola-\${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/\${finalAttrs.version}/festvox_\${finalAttrs.voiceName}.tar.gz";
    hash = "$hash";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "\$out"
    cp -r lib "\$out/lib"

    ln -s "\${
      mbrola-voices.override { languages = [ finalAttrs.voiceName ]; }
    }/data/\${finalAttrs.voiceName}" \
      "\$out/lib/voices/english/\${finalAttrs.voiceName}_mbrola/\${finalAttrs.voiceName}"

    runHook postInstall
  '';

  passthru.extraBinPath = [ mbrola ];

  meta = with lib; {
    description = "Festival MBROLA $lang voice \${finalAttrs.voiceName}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
EOF
    else
        cat >"$outdir/default.nix" <<-EOF
{
  lib,
  fetchurl,
  buildFestivalVoice,
  ...
}:

buildFestivalVoice (finalAttrs: {
  voiceName = "$v";
  pname = "festvox-$(echo "$v" | tr '_' '-')";
  version = "2.5";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/\${finalAttrs.version}/voices/festvox_\${finalAttrs.voiceName}$cg_suffix.tar.gz";
    hash = "$hash";
  };

  meta = with lib; {
    description = "Festival $lang voice \${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
EOF
    fi

    echo "  ✓ $outdir/default.nix"
done
