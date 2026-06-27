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

      package = mkOption {
        type = types.package;
        default = pkgs.festival;
        defaultText = "pkgs.festival";
        description = ''
          The Festival package to use.
        '';
      };

      defaultVoice = mkOption {
        type = types.functionTo types.package;
        default = voices: voices.kal_diphone;
        defaultText = literalExpression "voices: voices.kal_diphone";
        example = literalExpression "voices: voices.cmu_us_slt_cg";
        description = ''
          The voice Festival should use by default. The voice is automatically
          included — you do not need to repeat it in {option}`extraVoices`.
        '';
      };

      extraVoices = mkOption {
        default = _voices: [ ];
        type = types.functionTo (types.listOf types.package);
        defaultText = literalExpression "voices: [ ]";
        example = literalExpression "voices: with voices; [ kal_diphone cmu_us_aew ]";
        description = ''
          Extra voices available to Festival. The argument is
          {option}`festival.passthru.packages`. To get a list of
          available packages run:
          {command}`nix-env -f '<nixpkgs>' -qaP -A festivalVoices`.
        '';
      };

      extraSiteInit = mkOption {
        type = types.lines;
        default = "";
        example = literalExpression ''
          "(set! Duration_Stretch 1.2)"
        '';
        description = ''
          Extra Scheme code to append to Festival's {file}`siteinit.scm`.
          Useful for tuning voice parameters or loading additional modules.
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
    programs.festival.finalPackage =
      let
        defaultVoicePkg = cfg.defaultVoice cfg.package.packages;
        allVoices = voices: cfg.extraVoices voices ++ [ (cfg.defaultVoice voices) ];
      in
      (cfg.package.override { inherit (cfg) withSpeechdSupport; }).withSiteInitConfig allVoices {
        defaultVoice = defaultVoicePkg.passthru.voiceName;
        extraSiteInit = cfg.extraSiteInit;
      };

    environment.systemPackages = [ cfg.finalPackage ];
  };
}
