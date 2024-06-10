{
  pkgs, 
  lib,
  config,
  ...
}:
{
  imports = [];
 
  options = {
    my.tts.enable = 
      lib.mkEnableOption "enables text to speech config";
  };

  config = lib.mkIf config.my.sddm.enable {
    environment.systemPackages = with pkgs; [ 
      speechd
      # piper-tts
      espeak
      ];

    # download voices with piper through pied
    # https://github.com/Elleo/pied?tab=readme-ov-file
  };

}
