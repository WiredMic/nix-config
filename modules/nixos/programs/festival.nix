{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.festival;

in
{
  meta.maintainers = [ lib.maintainers.WiredMic ];

  options = {
    programs.festival = {
      enable = lib.mkEnableOption "Festival";

      package = lib.mkPackageOption pkgs "festival" { };

      defaultVoice = mkOption {
        type = types.enum (lib.attrNames pkgs.festival.packages);
        default = "kallpc16k";
        example = literalExpression "kallpc16k";
        description = ''
          The voice Festival should use by default. The voice is automatically
          included — you do not need to repeat it in {option}`extraVoices`.
        '';
      };

      extraVoices = mkOption {
        default = _voices: [ ];
        type = types.functionTo (types.listOf types.package);
        defaultText = literalExpression "voices: [ ]";
        example = literalExpression "voices: with voices; [ kallpc16k cmu_us_aew ]";
        description = ''
          Extra voices available to Festival. The argument is
          {option}`festival.passthru.packages`. To get a list of
          available packages run:
          {command}`nix-env -f '<nixpkgs>' -qaP -A festivalVoices`.
        '';
      };

      withSpeechdSupport = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables support for interoperebilly on festivals side between festival and speech-dispathcer.
          Note:
           - Do not add to many voices to festival
           - Festival still needs to be avaliable as a daemon (see {option}`sevices.festival`) 
        '';

      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Festival package including any overrides and extra voices.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];

    programs.festival.finalPackage =
      let
        allVoices =
          voices:
          cfg.extraVoices voices ++ lib.optional (cfg.defaultVoice != null) voices.${cfg.defaultVoice};
      in
      (cfg.package.override { inherit (cfg) withSpeechdSupport; }).withDefaultVoice allVoices
        cfg.defaultVoice;
  };
}
