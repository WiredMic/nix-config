{
  pkgs,
  lib,
  config,
  ...
}:
let
  # piperVoices = pkgs.callPackage ./packages/piper-voices.nix { };

  # voiceList = with piperVoices; [
  #   da_DK.talesyntese.medium
  #   en_US.lessac.low
  #   en_US.lessac.medium
  #   en_US.lessac.high
  # ];

  # selectedVoices = piperVoices.combineVoices voiceList;

  # generateAddVoice =
  #   voice:
  #   let
  #     locale = "${voice.language}-${voice.country}";
  #     voiceType = if voice.gender == "male" then "MALE1" else "FEMALE1";
  #   in
  #   ''AddVoice "${locale}" "${voiceType}" "${voice.voiceName}.onnx"'';

  # addVoiceEntries = lib.concatMapStringsSep "\n" generateAddVoice voiceList;

  # speechd-package = pkgs.speechd;

  # spd-piper-test = pkgs.writeShellScriptBin "spd-piper-test" ''
  #   ${pkgs.coreutils}/bin/echo "Så skal vi til det igen. Der er mere sne på vej, og det ser ud til at ramme store dele af landet fra onsdag formiddag og fortsætter op igennem dagen." | \
  #   ${pkgs.piper-tts}/bin/piper --model ${selectedVoices}/share/piper-voices/da_DK-talesyntese-medium.onnx --length_scale .67 --volume 1 --sentence_silence 0.1 -f - | \
  #   ${pkgs.pipewire}/bin/pw-play --format=s16 --rate=22050 --channels=1 --volume 5 -
  # '';

in
{
  options = {
    my.tts.enable = lib.mkEnableOption "enables text to speech config";
  };

  config = lib.mkIf config.my.tts.enable {
    environment.systemPackages = with pkgs; [
      # espeak
      piper-tts
      # spd-piper-test
      kdePackages.qtspeech
      # festivalFull
    ];

    programs.festival = {
      enable = true;
      package = pkgs.festival;
      defaultVoice = "us1_mbrola";
      extraVoices =
        voices: with voices; [
          kal_diphone
          rab_diphone
        ];
      withSpeechdSupport = true;
    };

    services.festival.enable = true;

    services.speechd = {
      enable = true;
      package = pkgs.speechd.override {
        withEspeak = false;
        withPico = true;
        withFlite = false;
      };
      modules = {
        # festival = builtins.readFile "${pkgs.speechd}/etc/speech-dispatcher/modules/festival.conf";
        festival = ''
          ${builtins.readFile "${pkgs.speechd}/etc/speech-dispatcher/modules/festival.conf"}
        '';
        pico = builtins.readFile "${pkgs.speechd}/etc/speech-dispatcher/modules/pico.conf";
      };
      config = ''

        # -----LOGGING CONFIGURATION-----
        LogLevel 5
        LogDir "/tmp/speechd-log"


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

        #AddModule "espeak"                   "sd_espeak"                                                                   "${pkgs.speechd}/etc/speech-dispatcher/modules/espeak.conf"
        #AddModule "espeak-ng"                "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_espeak-ng"           "${pkgs.speechd}/etc/speech-dispatcher/modules/espeak-ng.conf"
        #AddModule "flite"                    "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_flite"               "${pkgs.speechd}/etc/speech-dispatcher/modules/flite.conf"
        #AddModule "ivona"                    "sd_ivona"                                                                    "ivona.conf"
        #AddModule "piper"                    "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic" "piper.conf"
        #AddModule "espeak-ng-mbrola"         "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_espeak-ng-mbrola"    "${pkgs.speechd}/etc/speech-dispatcher/modules/espeak-ng-mbrola.conf"
        #AddModule "espeak-ng-mbrola-generic" "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/espeak-ng-mbrola-generic.conf"
        #AddModule "espeak-mbrola-generic"    "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/espeak-mbrola-generic.conf"
        #AddModule "swift-generic"            "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/swift-generic.conf"
        #AddModule "epos-generic"             "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/epos-generic.conf"
        #AddModule "dtk-generic"              "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/dtk-generic.conf"
        #AddModule "ibmtts"                   "sd_ibmtts"                                                                   "ibmtts.conf"
        #AddModule "cicero"                   "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_cicero"              "${pkgs.speechd}/etc/speech-dispatcher/modules/cicero.conf"
        #AddModule "kali"                     "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_kali"                "${pkgs.speechd}/etc/speech-dispatcher/modules/kali.conf"
        #AddModule "mary-generic"             "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_generic"             "${pkgs.speechd}/etc/speech-dispatcher/modules/mary-generic.conf"
        #AddModule "baratinoo"                "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_baratinoo"           "${pkgs.speechd}/etc/speech-dispatcher/modules/baratinoo.conf"
        #AddModule "rhvoice"                  "sd_rhvoice"                                                                  "rhvoice.conf"
        #AddModule "voxin"                    "${pkgs.speechd}/libexec/speech-dispatcher-modules/sd_voxin"               "${pkgs.speechd}/etc/speech-dispatcher/modules/voxin.conf"


        DefaultModule festival

        #LanguageDefaultModule "da"  "piper"
        #LanguageDefaultModule "cs"  "festival"
        #LanguageDefaultModule "es"  "festival"

        # -----CLIENT SPECIFIC CONFIGURATION-----

        Include "${pkgs.speechd}/etc/speech-dispatcher/clients/*.conf"
      '';

      # modules.piper = ''
      #   Debug 1

      #   GenericExecuteSynth "${pkgs.coreutils}/bin/printf %s \"$DATA\" | ${pkgs.piper-tts}/bin/piper --model ${selectedVoices}/share/piper-voices/$VOICE --length_scale $(${pkgs.bc}/bin/bc -l <<< \"scale=2; e(-1 * $RATE/100 * l(4))\") --volume 1 --sentence_silence 0.1 -f - | ${pkgs.pipewire}/bin/pw-play --format=s16 --rate=22050 --channels=1 --volume=$(${pkgs.bc}/bin/bc <<< \"scale=2; ($VOLUME * 5) / 100\") -"

      #   GenericCmdDependency "${pkgs.piper-tts}/bin/piper"
      #   GenericCmdDependency "${pkgs.pipewire}/bin/pw-play"
      #   GenericCmdDependency "${pkgs.coreutils}/bin/printf"
      #   GenericCmdDependency "${pkgs.bc}/bin/bc"

      #   GenericDefaultCharset "utf-8"

      #   # Add explicit language support
      #   GenericLanguage "da" "da-DK" "utf-8"

      #   ${addVoiceEntries}

      #   DefaultVoice "da_DK-talesyntese-medium.onnx"

      #   GenericDefaultVoice "en-US" "en_US-lessac-medium.onnx"
      #   GenericDefaultVoice "da-DK" "da_DK-talesyntese-medium.onnx"
      # '';
    };
  };
}
