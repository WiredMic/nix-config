{
  runTest,
  lib,
  pkgs,
  self,
}:
{
  # keep-sorted start case=no
  espeak-ng-alsa = runTest (import ./espeak-ng-libao.nix { inherit self pkgs lib; });
  espeak-ng-libao = runTest (import ./espeak-ng-libao.nix { inherit self pkgs lib; });
  espeak-ng-oss = runTest (import ./espeak-ng-libao.nix { inherit self pkgs lib; });
  espeak-ng-pipewire = runTest (import ./espeak-ng-libao.nix { inherit self pkgs lib; });
  espeak-ng-pulse = runTest (import ./espeak-ng-libao.nix { inherit self pkgs lib; });
  festival = runTest (import ./festival.nix { inherit self pkgs lib; });
  # keep-sorted end
}
