# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
final: prev: {
  scadformat = final.callPackage ./scadformat/package.nix { };
  festival = final.callPackage ./festival/package.nix {
    speech-tools = final.speech-tools;
  };
  festivalVoices = final.lib.recurseIntoAttrs final.festival.packages;
  speech-tools = final.callPackage ./speech-tools/package.nix { };
  festivalTest = final.festival.withVoices (voices: with voices; [ voices.cmu_us_awb ]);
}
