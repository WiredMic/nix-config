{ config, lib, pkgs, ... }:

{
  options = { my.tofi.enable = lib.mkEnableOption "enables my tofi config"; };

  config = { programs.tofi.enable = true; };
}
