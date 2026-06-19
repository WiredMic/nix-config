#!/usr/bin/env bash

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

BASE_URL="http://festvox.org/packed/festival/2.5/voices"
CACHE_DIR="/tmp/festival-voices-cache"
mkdir -p "$CACHE_DIR"

rm -rf voices/*

for v in "${voices[@]}" "${special_voices[@]}"; do
    mkdir -p "voices/$v"

    if [[ " ${special_voices[*]} " =~ " ${v} " ]]; then
        # Special case: no _cg
        tarname="festvox_${v}.tar.gz"
        cg=""
    else
        tarname="festvox_${v}_cg.tar.gz"
        cg="_cg"
    fi

    url="$BASE_URL/$tarname"
    cache_file="$CACHE_DIR/$tarname"

    echo "Processing $v ..."

    # Download only if not already cached
    if [[ ! -f "$cache_file" ]]; then
        echo "  ↓ Downloading $tarname ..."
        curl -L -s --fail -o "$cache_file" "$url" || {
            echo "  Failed to download $tarname"
            continue
        }
    else
        echo "  ↺ Using cached file"
    fi

    hash=$(nix hash file --type sha256 --sri "$cache_file")

    echo $hash

    cat >"voices/$v/default.nix" <<-EOF
{ lib, fetchurl, buildFestivalVoice, ... }:

buildFestivalVoice {
  pname = "$v";
  version = "2.5";

  src = fetchurl {
    url = "${url}";
    hash = "${hash}";  
  };

  meta = with lib; {
    description = "Festival voice: $v";
    homepage = "http://festvox.org/";
    license = licenses.free;
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
EOF

    echo "Created $v/default.nix"

done
