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

    services.piper-tts = {
      enable = true;
      port = 5000;
      defaultVoice = pkgs.piperTtsVoices.en_US-ryan-high;
      voices = (
        v: with v; [
          en_US-ryan-low
          en_US-ryan-medium
          en_US-amy-medium
          da_DK-talesyntese-medium
        ]
      );
    };

    services.speechd = {
      enable = true;
      modules = {
        espeakNg.enable = false;
        festival = {
          enable = false;
          debug = true;
          port = config.services.festival.port;
        };
        pico.enable = false;
      };
      extraModules = {
        piper =
          let
            piperVoices = config.services.piper-tts.finalVoices;

            qualitySlot = {
              x_low = "MALE1";
              low = "MALE1";
              medium = "MALE2";
              high = "MALE3";
            };

            addVoiceLines = lib.concatStringsSep "\n" (
              map (
                v:
                let
                  lang = lib.toLower (builtins.replaceStrings [ "_" ] [ "-" ] v.language.code);
                  slot = qualitySlot.${v.quality} or "MALE1";
                in
                ''AddVoice "${lang}" "${slot}" "${v.key}"''
              ) piperVoices
            );

            synthScript = pkgs.writeShellApplication {
              name = "synth-script";
              runtimeInputs = [
                pkgs.nh
                pkgs.jq
                pkgs.curl
                pkgs.gawk
                pkgs.pulseaudio
              ];
              text = ''
                text="$1"
                play_command="$2"   # passed through from speechd's $PLAY_COMMAND
                rate="$3"           # passed through from speechd's $RATE
                voice="$4"          # passed through from speechd's $VOICE

                [ -z "$(printf '%s' "$text" | tr -d '[:space:]')" ] && exit 0

                if ! printf '%s' "$rate" | grep -qE '^-?[0-9]+(\.[0-9]+)?$'; then
                    rate=0
                fi

                # Fall back to a sane default if speechd sends nothing usable
                # (e.g. "no_voice" from module_getdefaultvoice, or empty).
                if [ -z "$voice" ] || [ "$voice" = "no_voice" ]; then
                    voice="en_US-ryan-medium"
                fi

                LENGTH_SCALE=$(awk -v r="$rate" 'BEGIN{print 1 - (r/100)*0.5}')

                tmpfile=$(mktemp)
                trap 'rm -f "$tmpfile"' EXIT

                http_code=$(
                  printf '%s' "$text" \
                    | jq -Rs --arg voice "$voice" --arg ls "$LENGTH_SCALE" \
                        '{text: ., voice: $voice, length_scale: ($ls|tonumber)}' \
                    | curl -s -o "$tmpfile" -w '%{http_code}' \
                        -X POST -H "Content-Type: application/json" -d @- \
                        http://localhost:5000/synthesize
                )

                if [ "$http_code" = "200" ]; then
                    eval "$play_command" < "$tmpfile"
                else
                    echo "piper synth failed (HTTP $http_code): $(head -c 300 "$tmpfile")" >&2
                fi

                exit 0
              '';
            };

          in
          ''
            Debug 1
            GenericCmdDependency "curl"
            GenericMaxChunkLength 300
            GenericDelimiters "."

            GenericExecuteSynth "${synthScript}/bin/synth-script '$DATA' '$PLAY_COMMAND' '$RATE' '$VOICE'"

            ${addVoiceLines}
          '';
      };
      extraConfig = ''
        AddModule "piper" "sd_generic" "piper.conf"
      '';
      logLevel = 5;
      logDir = "/tmp/speechd-log";
      defaultModule = "piper";
      audioOutputMethod = [ "libao" ];
    };
  };
}
