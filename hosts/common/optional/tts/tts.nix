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
      speechdSupport = true;
    };

    services.festival = {
      enable = true;
      port = 1314;
      extraSiteInit = "";
    };

    # systemctl restart --user festival.service && systemctl restart --user speech-dispatcher.service && systemctl restart --user speech-dispatcher.socket

    services.speechd.enable = lib.mkForce false;

    services.speechd2 = {
      enable = true;
      modules = {
        espeakNg.enable = true;
        festival = {
          enable = true;
          debug = true;
          port = config.services.festival.port;
        };
        pico.enable = true;
      };
      extraModules = {
      };
      logLevel = 4;
      logDir = "/tmp/speechd-log";
      defaultModule = "festival";
      extraConfig = "";
    };
  };
}
