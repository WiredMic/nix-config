{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
let
  piperVoices = pkgs.callPackage ./packages/piper-voices.nix { };

  voiceList = with piperVoices; [
    da_DK.talesyntese.medium
    en_US.lessac.low
    en_US.lessac.medium
    en_US.lessac.high
  ];

  selectedVoices = piperVoices.combineVoices voiceList;

  generateAddVoice =
    voice:
    let
      locale = "${voice.language}-${voice.country}";
      voiceType = if voice.gender == "male" then "MALE1" else "FEMALE1";
    in
    ''AddVoice "${locale}" "${voiceType}" "${voice.voiceName}.onnx"'';

  addVoiceEntries = lib.concatMapStringsSep "\n" generateAddVoice voiceList;

  speechd-package = pkgs.speechd;

  spd-piper-test = pkgs.writeShellScriptBin "spd-piper-test" ''
    ${pkgs.coreutils}/bin/echo "Så skal vi til det igen. Der er mere sne på vej, og det ser ud til at ramme store dele af landet fra onsdag formiddag og fortsætter op igennem dagen." | \
    ${pkgs.piper-tts}/bin/piper --model ${selectedVoices}/share/piper-voices/da_DK-talesyntese-medium.onnx --length_scale .67 --volume 1 --sentence_silence 0.1 -f - | \
    ${pkgs.pipewire}/bin/pw-play --format=s16 --rate=22050 --channels=1 --volume 5 -
  '';

in
{
  options = {
    my.tts.enable = lib.mkEnableOption "enables text to speech config";
  };

  config = lib.mkIf config.my.tts.enable {
    environment.systemPackages = with pkgs; [
      # espeak
      piper-tts
      selectedVoices
      spd-piper-test
      kdePackages.qtspeech
    ];

    services.speechd = {
      enable = true;
      package = speechd-package.override {
        withEspeak = false;
        withPico = true;
        withFlite = false;
      };
      config = ''

        # -----LOGGING CONFIGURATION-----
        LogLevel  3
        LogDir  "default"


        # ----- VOICE PARAMETERS -----
        DefaultVolume 100


        # -----SPELLING/PUNCTUATION/CAPITAL LETTERS  CONFIGURATION-----

        SymbolsPreproc "char"

        SymbolsPreprocFile "gender-neutral.dic"
        SymbolsPreprocFile "font-variants.dic"
        SymbolsPreprocFile "symbols.dic"
        SymbolsPreprocFile "emojis.dic"
        SymbolsPreprocFile "orca.dic"
        SymbolsPreprocFile "orca-chars.dic"



        # -----OUTPUT MODULES CONFIGURATION-----

        #AddModule "espeak"                   "sd_espeak"                                                                   "${speechd-package}/etc/speech-dispatcher/modules/espeak.conf"
        #AddModule "espeak-ng"                "${speechd-package}/libexec/speech-dispatcher-modules/sd_espeak-ng"           "${speechd-package}/etc/speech-dispatcher/modules/espeak-ng.conf"
        #AddModule "festival"                 "${speechd-package}/libexec/speech-dispatcher-modules/sd_festival"            "${speechd-package}/etc/speech-dispatcher/modules/festival.conf"
        #AddModule "flite"                    "${speechd-package}/libexec/speech-dispatcher-modules/sd_flite"               "${speechd-package}/etc/speech-dispatcher/modules/flite.conf"
        #AddModule "ivona"                    "sd_ivona"                                                                    "ivona.conf"
        AddModule "pico"                     "${speechd-package}/libexec/speech-dispatcher-modules/sd_pico"                "${speechd-package}/etc/speech-dispatcher/modules/pico.conf"
        AddModule "piper" "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic" "piper.conf"
        #AddModule "espeak-ng-mbrola"         "${speechd-package}/libexec/speech-dispatcher-modules/sd_espeak-ng-mbrola"    "${speechd-package}/etc/speech-dispatcher/modules/espeak-ng-mbrola.conf"
        #AddModule "espeak-ng-mbrola-generic" "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/espeak-ng-mbrola-generic.conf"
        #AddModule "espeak-mbrola-generic"    "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/espeak-mbrola-generic.conf"
        #AddModule "swift-generic"            "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/swift-generic.conf"
        #AddModule "epos-generic"             "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/epos-generic.conf"
        #AddModule "dtk-generic"              "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/dtk-generic.conf"
        #AddModule "ibmtts"                   "sd_ibmtts"                                                                   "ibmtts.conf"
        #AddModule "cicero"                   "${speechd-package}/libexec/speech-dispatcher-modules/sd_cicero"              "${speechd-package}/etc/speech-dispatcher/modules/cicero.conf"
        #AddModule "kali"                     "${speechd-package}/libexec/speech-dispatcher-modules/sd_kali"                "${speechd-package}/etc/speech-dispatcher/modules/kali.conf"
        #AddModule "mary-generic"             "${speechd-package}/libexec/speech-dispatcher-modules/sd_generic"             "${speechd-package}/etc/speech-dispatcher/modules/mary-generic.conf"
        #AddModule "baratinoo"                "${speechd-package}/libexec/speech-dispatcher-modules/sd_baratinoo"           "${speechd-package}/etc/speech-dispatcher/modules/baratinoo.conf"
        #AddModule "rhvoice"                  "sd_rhvoice"                                                                  "rhvoice.conf"
        #AddModule "voxin"                    "${speechd-package}/libexec/speech-dispatcher-modules/sd_voxin"               "${speechd-package}/etc/speech-dispatcher/modules/voxin.conf"


        DefaultModule piper

        LanguageDefaultModule "da"  "piper"
        #LanguageDefaultModule "cs"  "festival"
        #LanguageDefaultModule "es"  "festival"

        # -----CLIENT SPECIFIC CONFIGURATION-----

        Include "${speechd-package}/etc/speech-dispatcher/clients/*.conf"
      '';

      modules.piper = ''
        Debug 1

        GenericExecuteSynth "${pkgs.coreutils}/bin/printf %s \"$DATA\" | ${pkgs.piper-tts}/bin/piper --model ${selectedVoices}/share/piper-voices/$VOICE --length_scale $(${pkgs.bc}/bin/bc -l <<< \"scale=2; e(-1 * $RATE/100 * l(4))\") --volume 1 --sentence_silence 0.1 -f - | ${pkgs.pipewire}/bin/pw-play --format=s16 --rate=22050 --channels=1 --volume=$(${pkgs.bc}/bin/bc <<< \"scale=2; ($VOLUME * 5) / 100\") -"


        GenericCmdDependency "${pkgs.piper-tts}/bin/piper"
        GenericCmdDependency "${pkgs.pipewire}/bin/pw-play"
        GenericCmdDependency "${pkgs.coreutils}/bin/printf"
        GenericCmdDependency "${pkgs.bc}/bin/bc"

        GenericDefaultCharset "utf-8"

        # Add explicit language support
        GenericLanguage "da" "da-DK" "utf-8"


        ${addVoiceEntries}

        DefaultVoice "da_DK-talesyntese-medium.onnx"

        GenericDefaultVoice "en-US" "en_US-lessac-medium.onnx"
        GenericDefaultVoice "da-DK" "da_DK-talesyntese-medium.onnx"
      '';
    };
  };
}
