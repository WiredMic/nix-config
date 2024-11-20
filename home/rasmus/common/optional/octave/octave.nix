{ config, lib, pkgs, ... }:

{
  imports = [ ];

  options = {
    my.octave.enable = lib.mkEnableOption "enables octave and other packages";
  };

  config = lib.mkIf config.my.octave.enable {

    home.packages = with pkgs; [
      (octaveFull.withPackages (opkgs:
        with opkgs; [
          symbolic
          quaternion
          # (callPackage ./clifford-multivector-toolbox.nix { })
        ]))
      ghostscript
    ];
  };
}
