{
  lib,
  pkgs,
  mkEnableOption,
  mkOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Openjtalk text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  displayName = "Open JTalk";
  binary = "sd_openjtalk";
  confFiles = [
    "openjtalk.conf"
  ];
  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/openjtalk.conf".text =
        (builtins.readFile "${cfg.package}/etc/speech-dispatcher/modules/openjtalk.conf")
        + "\n"
        + modCfg.extraConfig;
    };
}
