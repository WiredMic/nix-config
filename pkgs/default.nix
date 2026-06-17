# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
final: prev: {
  scadformat = final.callPackage ./scadformat/package.nix { };
  festival = final.callPackage ./festival/package.nix {
    speech-tools = final.speech-tools;
  };
  speech-tools = final.callPackage ./speech-tools/package.nix { };
}
