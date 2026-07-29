# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
final: prev: {
  scadformat = final.callPackage ./scadformat/package.nix { };

  piper-tts = final.callPackage ./piper-tts/package.nix { };
  piperTtsVoices = final.lib.recurseIntoAttrs (final.callPackage ./piper-tts/voices { });

  speech-tools = final.callPackage ./speech-tools/package.nix { };

  festival-czech = final.callPackage ./festival-czech/package.nix { };

  festival = final.callPackage ./festival/package.nix { };
  festivalVoices = final.lib.recurseIntoAttrs (final.callPackage ./festival/voices { });

  upc_ca_base = final.callPackage ./upc_ca_base/package.nix { };

  sound-icons = final.callPackage ./sound-icons/package.nix { };
}
