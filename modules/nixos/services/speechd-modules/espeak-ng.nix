{
  lib,
  pkgs,
  mkEnableOption,
  mkPackageOption,
  mkOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable eSpeak NG text-to-speech output module.";
      };
      package = mkPackageOption pkgs "espeak-ng" { };
      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable debug output.";
        example = true;
      };
      soundIconFolder = mkOption {
        type = lib.types.path;
        default = "${pkgs.sound-icons}/share/sounds/sound-icons";
        defaultText = lib.literalExpression ''"''${pkgs.sound-icons}/share/sounds/sound-icons"'';
        description = ''
          Path to a directory containing sound icon WAV files.
          When an application requests a sound icon by name, eSpeak NG will
          look for a matching file in this directory and play it instead of
          speaking the icon name.

          Sets {var}`EspeakSoundIconFolder`.
        '';
        example = lib.literalExpression ''"''${pkgs.sound-icons}/share/sounds/sound-icons"'';
      };
      punctuationList = mkOption {
        type = lib.types.str;
        default = "@+_";
        description = ''
          Characters to be spoken when the punctuation setting is
          {literal}`some`.

          Sets {var}`EspeakPunctuationList`.
        '';
        example = "@/+-_";
      };
      capitalPitchRise = mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Pitch increase (in Hz) used to indicate a capital letter when the
          capital letter recognition mode is set to pitch.
          Values {literal}`1` and {literal}`2` are reserved and will be
          reset to {literal}`0`.

          Sets {var}`EspeakCapitalPitchRise`.
        '';
        example = 800;
      };
      minRate = mkOption {
        type = lib.types.int;
        default = 80;
        description = ''
          Minimum speech rate in words per minute. Corresponds to
          {literal}`-100` in Speech Dispatcher's rate scale.

          Sets {var}`EspeakMinRate`.
        '';
        example = 80;
      };

      normalRate = mkOption {
        type = lib.types.int;
        default = 170;
        description = ''
          Normal speech rate in words per minute. Corresponds to
          {literal}`0` in Speech Dispatcher's rate scale.

          Sets {var}`EspeakNormalRate`.
        '';
        example = 170;
      };

      maxRate = mkOption {
        type = lib.types.int;
        default = 449;
        description = ''
          Maximum speech rate in words per minute. Corresponds to
          {literal}`+100` in Speech Dispatcher's rate scale.

          Sets {var}`EspeakMaxRate`.
        '';
        example = 449;
      };
      audioChunkSize = mkOption {
        type = lib.types.int;
        default = 300;
        description = ''
          Duration in milliseconds of audio chunks returned by the eSpeak
          callback function.

          Sets {var}`EspeakAudioChunkSize`.
        '';
        example = 300;
      };

      audioQueueMaxSize = mkOption {
        type = lib.types.int;
        default = 441000;
        description = ''
          Maximum number of samples to buffer in the playback queue.

          Sets {var}`EspeakAudioQueueMaxSize`.
        '';
        example = 441000;
      };

      indexing = mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable speech indexing, which allows Speech Dispatcher to track
          position within a spoken message for pause and resume support.

          Sets {var}`EspeakIndexing`.
        '';
      };
      mbrola = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enabling this makes eSpeak NG only show MBROLA voices.

          Sets {var}`EspeakMbrola`.
        '';
        example = "true";
      };

      extraConfig = mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Additional lines appended verbatim to the eSpeak NG module
          configuration file.
        '';
        example = ''
          EspeakAudioChunkSize 500
        '';
      };
    };
  };

  displayName = "eSpeak NG";
  binary = modCfg: if modCfg.mbrola then "sd_espeak-ng-mbrola" else "sd_espeak-ng";
  confFile = "espeak-ng.conf";
  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/espeakNg.conf".text = ''
        Debug ${toString modCfg.debug}
        EspeakSoundIconFolder "${modCfg.soundIconFolder}/"
        EspeakPunctuationList "${modCfg.punctuationList}"
        EspeakCapitalPitchRise ${toString modCfg.capitalPitchRise}
        EspeakMinRate ${toString modCfg.minRate}
        EspeakNormalRate ${toString modCfg.normalRate}
        EspeakMaxRate ${toString modCfg.maxRate}
        EspeakAudioChunkSize ${toString modCfg.audioChunkSize}
        EspeakAudioQueueMaxSize ${toString modCfg.audioQueueMaxSize}
        EspeakIndexing ${toString modCfg.indexing}
        EspeakMbrola ${toString modCfg.mbrola}
      ''
      + "\n"
      + modCfg.extraConfig;
    };

  assertions =
    modCfg:
    lib.mapAttrsToList
      (directive: option: {
        assertion = !(lib.hasInfix directive modCfg.extraConfig);
        message = ''
          services.speechd.modules.espeakNg.extraConfig contains an ${directive} directive.
          Use services.speechd.modules.espeakNg.${option} instead.
        '';
      })
      {
        Debug = "debug";
        EspeakSoundIconFolder = "soundIconFolder";
        EspeakPunctuationList = "punctuationList";
        EspeakCapitalPitchRise = "capitalPitchRise";
        EspeakMinRate = "minRate";
        EspeakNormalRate = "normalRate";
        EspeakMaxRate = "maxRate";
        EspeakAudioChunkSize = "audioChunkSize";
        EspeakAudioQueueMaxSize = "audioQueueMaxSize";
        EspeakIndexing = "indexing";
      };
}
