{
  lib,
  stdenv,
  runCommand,
  festival,
}:

attrsOrFn:

let
  attrs = if lib.isFunction attrsOrFn then lib.fix attrsOrFn else attrsOrFn;
  voiceName = attrs.voiceName;
in

stdenv.mkDerivation (
  finalAttrs:
  {
    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r lib "$out/lib"

      runHook postInstall
    '';

    passthru.isFestivalVoice = true;

    # The tests are
    # 1. Catch SIOD ERROR as errors even if sound is produced
    # 2. Catch to see if the voice can produce sound
    #   - If sound is produces the file must be bigger
    #     than the header size of a wave file (44 B)
    passthru.tests.synthesizes =
      runCommand "${finalAttrs.pname}-test"
        {
          nativeBuildInputs = [
            (festival.withDefaultVoice (_: [ finalAttrs.finalPackage ]) voiceName)
          ];
        }
        ''
          tmpfile=$(mktemp /tmp/XXXXXX.wav)
          output=$(echo "(utt.save.wave \
            (utt.synth (Utterance Text \"hello world\")) \
            \"$tmpfile\")" | festival 2>&1) && festivalExit=0 || festivalExit=$?
          if echo "$output" | grep -q "SIOD ERROR"; then
            echo "SIOD ERROR detected:"
            echo "$output" | grep "SIOD ERROR"
            exit 1
          fi
          size=$(stat -c%s "$tmpfile")
          test $size -gt 44 || (echo "No audio generated (only $size bytes)" && exit 1)
          mkdir $out
        '';

    meta.platforms = lib.platforms.all;

  }
  // attrs
)
