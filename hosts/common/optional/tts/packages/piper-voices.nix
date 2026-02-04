{
  pkgs,
  lib,
  config,
  fetchurl,
  ...
}:

let
  # Helper function to create a single voice package
  mkPiperVoice =
    {
      language,
      country,
      voice,
      quality,
      gender,
      onnxSrc,
      jsonSrc,
    }:
    let
      voiceName = "${language}_${country}-${voice}-${quality}";
    in
    pkgs.stdenv.mkDerivation {
      pname = "piper-voice-${voiceName}";
      version = "1.0.0";

      onnxFile = onnxSrc;
      jsonFile = jsonSrc;

      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/share/piper-voices
        cp $onnxFile $out/share/piper-voices/${voiceName}.onnx
        cp $jsonFile $out/share/piper-voices/${voiceName}.onnx.json
      '';

      passthru = {
        inherit
          language
          country
          voice
          quality
          gender
          voiceName
          ;
      };

      meta = with lib; {
        description = "Piper TTS voice: ${voiceName}";
        homepage = "https://github.com/rhasspy/piper";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };

  # Helper to combine multiple voices
  combineVoices =
    voices:
    pkgs.symlinkJoin {
      name = "piper-voices-combined";
      paths = voices;
    };

  huggingfaceUrl = "https://huggingface.co/rhasspy/piper-voices/resolve/main";
in
{
  inherit mkPiperVoice combineVoices;
  # https://huggingface.co/rhasspy/piper-voices/blob/main/da/da_DK/talesyntese/medium/da_DK-talesyntese-medium.onnx
  # Danish voices
  da_DK = {
    talesyntese = {
      medium =
        let
          language = "da";
          country = "DK";
          voice = "talesyntese";
          quality = "medium";
          baseUrl = "${huggingfaceUrl}/${language}/${language}_${country}/${voice}/${quality}/${language}_${country}-${voice}-${quality}";
        in
        mkPiperVoice rec {
          inherit
            language
            country
            voice
            quality
            ;
          gender = "male";
          onnxSrc = fetchurl {
            url = "${baseUrl}.onnx";
            sha256 = "sha256-uSce/SX3uElLvSjUjdZ1yMEZ2qKE8+5IgAiTX1FfEkE=";
          };
          jsonSrc = fetchurl {
            url = "${baseUrl}.onnx.json";
            sha256 = "sha256-if4TvSUUBswAiFcNED6nrDWCMhHYRm+vkTJoq4UG9Bs=";
          };
        };
    };
  };

  # English (US) voices
  en_US = {
    lessac = {
      low =
        let
          language = "en";
          country = "US";
          voice = "lessac";
          quality = "low";
          baseUrl = "${huggingfaceUrl}/${language}/${language}_${country}/${voice}/${quality}/${language}_${country}-${voice}-${quality}";
        in
        mkPiperVoice {
          inherit
            language
            country
            voice
            quality
            ;
          gender = "male";
          onnxSrc = fetchurl {
            url = "${baseUrl}.onnx";
            sha256 = "sha256-99Ad3jcVVXMsTDFBEax5ZysaXOL8GSZqtCF4/Y3383U=";
          };
          jsonSrc = fetchurl {
            url = "${baseUrl}.onnx.json";
            sha256 = "sha256-RXVN/euzuGYcP8VkcTdy3uxuBk/utbTpWUhX3HMFGTo=";
          };

        };
      medium =
        let
          language = "en";
          country = "US";
          voice = "lessac";
          quality = "medium";
          baseUrl = "${huggingfaceUrl}/${language}/${language}_${country}/${voice}/${quality}/${language}_${country}-${voice}-${quality}";
        in
        mkPiperVoice {
          inherit
            language
            country
            voice
            quality
            ;
          gender = "male";
          onnxSrc = fetchurl {
            url = "${baseUrl}.onnx";
            sha256 = "sha256-Xv4J5pkCGHgnr2RuGm6dJp3udp+Yd9F7FrG0buqvAZ8=";
          };
          jsonSrc = fetchurl {
            url = "${baseUrl}.onnx.json";
            sha256 = "sha256-7+GcQXvtBV8taZCCSMa6ZQ+hNbyGiw5quz2hgdq2kKA=";
          };
        };
      high =
        let
          language = "en";
          country = "US";
          voice = "lessac";
          quality = "high";
          baseUrl = "${huggingfaceUrl}/${language}/${language}_${country}/${voice}/${quality}/${language}_${country}-${voice}-${quality}";
        in
        mkPiperVoice {
          inherit
            language
            country
            voice
            quality
            ;
          gender = "male";
          onnxSrc = fetchurl {
            url = "${baseUrl}.onnx";
            sha256 = "sha256-TKv3w6Y4AXE380oVFlIgMtT+PzgiioQ8ybdk3cvNngk=";
          };
          jsonSrc = fetchurl {
            url = "${baseUrl}.onnx.json";
            sha256 = "sha256-20K5fZhZ8le8FWG47ZgOf7I5hAIFCnTd1svskxqSQS8=";
          };
        };
    };

    #   ryan-low = mkPiperVoice {
    #     language = "en";
    #     country = "US";
    #     voice = "ryan";
    #     quality = "low";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };

    #   ryan-medium = mkPiperVoice {
    #     language = "en";
    #     country = "US";
    #     voice = "ryan";
    #     quality = "medium";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };

    #   ryan-high = mkPiperVoice {
    #     language = "en";
    #     country = "US";
    #     voice = "ryan";
    #     quality = "high";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };

    #   libritts-high = mkPiperVoice {
    #     language = "en";
    #     country = "US";
    #     voice = "libritts";
    #     quality = "high";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };
    # };

    # English (GB) voices
    # en_GB = {
    #   alan-low = mkPiperVoice {
    #     language = "en";
    #     country = "GB";
    #     voice = "alan";
    #     quality = "low";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };

    #   alan-medium = mkPiperVoice {
    #     language = "en";
    #     country = "GB";
    #     voice = "alan";
    #     quality = "medium";
    #     onnxSha256 = lib.fakeSha256;
    #     jsonSha256 = lib.fakeSha256;
    #   };
  };

  # Add more languages as needed...
  # de_DE = { ... };
  # es_ES = { ... };
  # fr_FR = { ... };
}
