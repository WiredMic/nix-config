{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    my.tts.enable = lib.mkEnableOption "enables text to speech config";
  };

  config = lib.mkIf config.my.tts.enable {
    environment.systemPackages = with pkgs; [
      piper-tts
      kdePackages.qtspeech
    ];

    # journalctl --user -u festival.service -f &
    # echo '(print (voice.list))' | festival_client

    programs.festival = {
      enable = true;
      package = pkgs.festival;
      defaultVoice = voice: voice.us1_mbrola;
      extraVoices =
        voices: with voices; [
          kal_diphone
          rab_diphone
          czech_mbrola_cz2
          upc_ca_bet_hts
        ];
      withSpeechdSupport = true;
    };

    services.festival = {
      enable = true;
    };

    systemd.user.services.speech-dispatcher = {
      restartTriggers = [ config.services.speechd.package ];
      after = [ "festival.service" ];
      bindsTo = [ "festival.service" ];
    };

    # systemctl restart --user festival.service && systemctl restart --user speech-dispatcher.service && systemctl restart --user speech-dispatcher.socket

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
        # https://htmlpreview.github.io/?https://github.com/brailcom/speechd/blob/master/doc/speech-dispatcher.html
        # -----LOGGING CONFIGURATION-----
        LogLevel 4
        LogFile "/tmp/speechd-log.log"


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

        DefaultModule festival

        # -----CLIENT SPECIFIC CONFIGURATION-----

        Include "${pkgs.speechd}/etc/speech-dispatcher/clients/*.conf"
      '';
    };
  };
}
