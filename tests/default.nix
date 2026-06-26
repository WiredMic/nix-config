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
  speechd = {
    festival = runTest (import ./speechd/festival.nix { inherit pkgs self lib; });
  };

  festival = runTest (import ./festival.nix { inherit pkgs self lib; });
}
# (
#   import ./speechd/default.nix {
#     inherit pkgs self;
#   }
# )
# future suites flattened in the same way:
# // (import ./voices/default.nix { inherit pkgs self; })
