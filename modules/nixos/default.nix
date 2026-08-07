# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  programs-festival = import ./programs/festival.nix;
  services-festival = import ./services/festival.nix;
  programs-piper-tts = import ./programs/piper-tts.nix;
  services-piper-tts = import ./services/piper-tts.nix;
  services-speechd = import ./services/speechd.nix;
  pulse-eight = import ./services/pulse-eight.nix;
}
