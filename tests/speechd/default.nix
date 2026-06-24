{
  runTest,
  lib,
  self,
}:
{
  festival = runTest ./festival.nix;
  # future tests alongside it:
  # speechd-piper  = import ./piper.nix  { inherit pkgs self; };
}
