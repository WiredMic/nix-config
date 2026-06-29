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
      enable = mkEnableOption "Festival text-to-speech output module.";
      port = mkOption {
        type = lib.types.port;
        default = 1314;
        description = ''
          Festival server port.
          Set the {var}`FestivalServerPort`.
        '';
        example = 6456;
      };
      host = mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Festival server host address.
          Set the {var}`FestivalServerHost`.
        '';
        example = "127.0.0.1";
      };
      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debug output.
        '';
        example = true;
      };
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  # Festival is not packaged in Nixpkgs.
  # However, it works on a server/client model.
  # Festival does not need to run on the same
  # machine as Speechd
  visible = true;
  displayName = "Festival";
  binary = "sd_festival";
  confFiles = [
    "festival.conf"
  ];
  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/festival.conf".text = ''
        Debug ${if modCfg.debug then "1" else "0"}
        FestivalServerHost ${toString modCfg.host}
        FestivalServerPort ${toString modCfg.port}
      ''
      + modCfg.extraConfig;
    };
}
