{ config, lib, pkgs, ... }:

{
  options = { my.tofi.enable = lib.mkEnableOption "enables my tofi config"; };

  config = {
    programs.tofi.enable = true;
    programs.tofi.settings = {
      background-color = lib.mkOptionDefault "#000000";
      border-width = lib.mkOptionDefault 0;
      font = lib.mkOptionDefault "monospace";
      height = lib.mkOptionDefault "100%";
      num-results = lib.mkOptionDefault 5;
      outline-width = lib.mkOptionDefault 0;
      padding-left = lib.mkOptionDefault "35%";
      padding-top = lib.mkOptionDefault "35%";
      result-spacing = lib.mkOptionDefault 25;
      width = lib.mkOptionDefault "100%";
    };
  };
}
