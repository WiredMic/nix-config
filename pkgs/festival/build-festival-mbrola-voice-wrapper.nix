{
  lib,
  stdenv,
  mbrola,
  mbrola-voices,
  runCommand,
  festival,
}:

attrsOrFn:

let
  attrs = if lib.isFunction attrsOrFn then lib.fix attrsOrFn else attrsOrFn;
  voiceName = attrs.voiceName or attrs.pname;
  voiceData = mbrola-voices.override { languages = [ voiceName ]; };
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

      ln -s "${voiceData}/data/${voiceName}" \
        "$out/lib/voices/english/${voiceName}_mbrola/${voiceName}"

      runHook postInstall
    '';

    passthru.isFestivalVoice = true;
    passthru.extraBinPath = [ mbrola ];

    # Test to see if festival with the speciffic voice generates a wave file
    # that is bigger than the header size of a wave file (44 B)
    passthru.tests.synthesizes =
      runCommand "${finalAttrs.pname}-test"
        {
          nativeBuildInputs = [
            (festival.withVoices (_: [ finalAttrs.finalPackage ]))
          ];
        }
        ''
          tmpfile=$(mktemp /tmp/XXXXXX.wav)
          echo "(voice_${voiceName}_mbrola)(utt.save.wave \
            (utt.synth (Utterance Text \"hello world\")) \
            \"$tmpfile\")" | festival 2>&1
          size=$(stat -c%s "$tmpfile")
          test $size -gt 44 || (echo "No audio generated" && exit 1)
          touch $out
        '';

    meta.platforms = lib.platforms.all;

  }
  // attrs
)
