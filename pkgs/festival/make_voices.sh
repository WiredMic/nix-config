#!/usr/bin/env bash
set -euo pipefail

voices=(
    cmu_us_aew cmu_us_ahw cmu_us_aup cmu_us_axb cmu_us_bdl cmu_us_clb
    cmu_us_eey cmu_us_fem cmu_us_gka cmu_us_jmk cmu_us_ksp cmu_us_ljm
    cmu_us_lnh cmu_us_rms cmu_us_rxr cmu_us_slp cmu_us_slt
    cmu_indic_ben_rm cmu_indic_guj_ad cmu_indic_guj_dp cmu_indic_guj_kt
    cmu_indic_hin_ab cmu_indic_kan_plv cmu_indic_mar_aup cmu_indic_mar_slp
    cmu_indic_pan_amp cmu_indic_tam_sdr cmu_indic_tel_kpn cmu_indic_tel_sk
    cmu_indic_tel_ss
)

special_voices=(
    kallpc16k rablpc16k
)

mbrola_voices=(us1 us2 us3 en1)

BASE_URL="http://festvox.org/packed/festival/2.5/voices"
BASE_WRAPPER_URL="https://www.cstr.ed.ac.uk/downloads/festival/1.95/"
CACHE_DIR="/tmp/festival-voices-cache"
mkdir -p "$CACHE_DIR"

rm -rf voices/*

for v in "${voices[@]}" "${special_voices[@]}" "${mbrola_voices[@]}"; do

    if [[ " ${mbrola_voices[*]} " =~ " ${v} " ]]; then
        tarname="festvox_${v}.tar.gz"
        url="$BASE_WRAPPER_URL/$tarname"
        outdir="voices/${v}_mbrola"
        cg_suffix=""
    elif [[ " ${special_voices[*]} " =~ " ${v} " ]]; then
        tarname="festvox_${v}.tar.gz"
        url="$BASE_URL/$tarname"
        outdir="voices/$v"
        cg_suffix=""
    else
        tarname="festvox_${v}_cg.tar.gz"
        url="$BASE_URL/$tarname"
        outdir="voices/$v"
        cg_suffix="_cg"
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

    if [[ " ${mbrola_voices[*]} " =~ " ${v} " ]]; then
        cat >"$outdir/default.nix" <<-EOF
{
  lib,
  fetchurl,
  buildFestivalMbrolaVoiceWrapper,
  ...
}:

buildFestivalMbrolaVoiceWrapper (finalAttrs: {
  voiceName = "$v";
  pname = "festvox-mbrola-\${finalAttrs.voiceName}";
  version = "1.95";

  src = fetchurl {
    url = "https://www.cstr.ed.ac.uk/downloads/festival/\${finalAttrs.version}/festvox_\${finalAttrs.voiceName}.tar.gz";
    hash = "$hash";
  };

  meta = with lib; {
    description = "Festival MBROLA voice \${finalAttrs.voiceName}";
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
    description = "Festival voice \${finalAttrs.pname}";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with maintainers; [ WiredMic ];
  };
})
EOF
    fi

    echo "  ✓ $outdir/default.nix"
done
