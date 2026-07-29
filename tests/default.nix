# tests/default.nix
{
  pkgs,
  self,
}:

let
  runTest = test: pkgs.testers.runNixOSTest test;
  lib = pkgs.lib;
in
{
  # festival = runTest (import ./festival.nix { inherit pkgs self lib; });
}
