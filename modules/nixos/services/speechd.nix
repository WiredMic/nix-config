{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd2;
  inherit (lib)
    mapAttrs'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    ;

  # keep-sorted start block=yes  newline_separated=yes case=no
  baratinooModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Baratinoo text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  ciceroModuleType = lib.types.submodule {
    options = {
      enablvisiblee = mkEnableOption "Cicero text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  dtkModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Dtk text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  eposModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Epos text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  espeakNgMbrolaModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "eSpeak NG using MBROLA text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  espeakNgModuleType = lib.types.submodule {
    options = {
      enable = mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable eSpeak NG text-to-speech output module.";
      };
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  festivalModuleType = lib.types.submodule {
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
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  fliteModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Flite text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  kaliModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Kali text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  # preliminary version
  lliaPhonModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Llia Phon text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  maryModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Mary text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  mimic3ModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Mimic3 text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  openjtalkModuleType = lib.types.submodule {
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

  picoModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Pico text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  swiftModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Swift text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };

  voxinModuleType = lib.types.submodule {
    options = {
      enable = mkEnableOption "Voxin text-to-speech output module.";
      extraConfig = mkOption {
        type = with lib.types; lines;
        default = "";
        description = "";
        example = "";
      };
    };
  };
  # keep-sorted end

  mkSimpleGenerateEtc =
    confFiles: modCfg:
    lib.optionalAttrs modCfg.enable (
      lib.mergeAttrsList (
        map (confFile: {
          "speech-dispatcher/modules/${confFile}".text =
            (builtins.readFile "${cfg.package}/etc/speech-dispatcher/modules/${confFile}")
            + "\n"
            + modCfg.extraConfig;
        }) confFiles
      )
    );

  mkSimpleAddModule =
    binary: confFile: ''AddModule "${lib.removeSuffix ".conf" confFile}" "${binary}" "${confFile}"'';

  outputModules =
    lib.mapAttrs
      (
        name: mod:
        let
          binary = mod.binary or "sd_generic";
        in
        mod
        // {
          inherit binary;
          generateEtc = mod.generateEtc or (mkSimpleGenerateEtc mod.confFiles);
          generateAddModule =
            mod.generateAddModule
              or (lib.concatMapStrings (confFile: mkSimpleAddModule binary confFile + "\n") mod.confFiles);
        }
      )
      {
        # keep-sorted start block=yes case=no
        baratinoo = {
          type = baratinooModuleType;
          # Baratinoo is not packaged in Nixpkgs
          visible = false;
          displayName = "Baratinoo";
          binary = "sd_baratinoo";
          confFiles = [
            "baratinoo.conf"
          ];
        };
        cicero = {
          type = ciceroModuleType;
          # Cicero is not packaged in Nixpkgs
          visible = false;
          displayName = "Cicero";
          binary = "sd_cicero";
          confFiles = [
            "cicero.conf"
          ];
        };
        dtk = {
          type = dtkModuleType;
          # Dtk is not packaged in Nixpkgs
          visible = false;
          displayName = "DTK";
          confFiles = [
            "dtk-generic.conf"
          ];
        };
        epos = {
          type = eposModuleType;
          # Epos is not packaged in Nixpkgs
          visible = false;
          displayName = "Epos";
          confFiles = [
            "epos-generic.conf"
          ];
        };
        espeakNg = {
          type = espeakNgModuleType;
          displayName = "eSpeak NG";
          binary = "sd_espeak-ng";
          confFiles = [
            "espeak-ng.conf"
          ];
        };
        espeakNgMbrola = {
          type = espeakNgMbrolaModuleType;
          displayName = "eSpeak NG MBROLA";
          binary = "sd_espeak-ng-mbrola";
          confFiles = [
            "espeak-ng-mbrola"
            "espeak-ng-mbrola-generic"
          ];
        };
        festival = {
          type = festivalModuleType;
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
                FestivalServerHost ${toString modCfg.host}
                FestivalServerPort ${toString modCfg.port}
              ''
              + modCfg.extraConfig;
            };
        };
        flite = {
          type = fliteModuleType;
          displayName = "Flite";
          binary = "sd_flite";
          confFiles = [
            "flite.conf"
          ];
        };
        kali = {
          type = kaliModuleType;
          # Kali is not packaged in Nixpkgs.
          visible = false;
          displayName = "Kali";
          binary = "sd_kali";
          confFiles = [
            "kali.conf"
          ];
        };
        lliaPhon = {
          type = lliaPhonModuleType;
          # Llia Phon is not packaged in Nixpkgs.
          visible = false;
          displayName = "Llia Phon";
          confFiles = [
            "llia_phon-generic.conf"
          ];
        };
        mary = {
          type = maryModuleType;
          displayName = "MaryTTS";
          confFiles = [
            "mary-generic.conf"
          ];
        };
        mimic3 = {
          type = mimic3ModuleType;
          displayName = "Mimic 3";
          confFiles = [
            "mimic3-generic.conf"
          ];
        };
        openjtalk = {
          type = openjtalkModuleType;
          displayName = "Open JTalk";
          binary = "sd_openjtalk";
          confFiles = [
            "openjtalk.conf"
          ];
        };
        pico = {
          type = picoModuleType;
          displayName = "SVOX Pico";
          binary = "sd_pico";
          confFiles = [
            "pico.conf"
          ];
        };
        swift = {
          type = swiftModuleType;
          #  SwiftTTS is not packaged in Nixpkgs.
          visible = false;
          displayName = "SwiftTTS";
          confFiles = [
            "swift-generic.conf"
          ];
        };
        voxin = {
          type = voxinModuleType;
          displayName = "Voxin";
          binary = "sd_voxin";
          confFiles = [
            "voxin.conf"
          ];
        };
        # keep-sorted end
      };

in
{
  options.services.speechd2 = {
    # FIXME: figure out how to deprecate this EXTREMELY CAREFULLY
    # default guessed conservatively in ../misc/graphical-desktop.nix
    enable = mkEnableOption "speech-dispatcher speech synthesizer daemon";

    package = mkPackageOption pkgs "speechd" { };

    logLevel = mkOption {
      type = lib.types.ints.between 0 5;
      default = 3;
      description = ''
        Specifies the verbosity of information written to the logfile  or screen.
        0 means nothing, 5 means everything (not recommended).

        Sets {var}`LogLevel`.
      '';
      example = "5";
    };

    logDir = mkOption {
      type = lib.types.either (lib.types.enum [
        "default"
        "stdout"
      ]) lib.types.str;
      default = "default";
      description = ''
        Directory where Speech Dispatcher logs are written.
        Use {var}`"default"` for the standard system log destination,
        {var}`"stdout"` for console output, or an absolute path to a
        custom directory.

        Sets {var}`LogDir`.
      '';
      example = "/var/log/speech-dispatcher/";
    };

    defaultVolume = mkOption {
      type = lib.types.ints.between (-100) 100;
      default = 100;
      description = ''
        Default volume of synthesized speech, ranging from -100 (quietest)
        to 100 (the synthesizer's default volume).

        Sets {var}`DefaultVolume`.
      '';
      example = "10";
    };

    symbolsPreproc = mkOption {
      type = lib.types.enum [
        "no"
        "none"
        "all"
        "char"
      ];
      default = "char";
      description = ''
        Controls the level of punctuation symbol pre-processing performed
        by the server rather than the output module.
        {var}`"no"` disables pre-processing entirely.
        {var}`"none"` enables only rules that are always active.
        {var}`"all"` enables all server punctuation rules.
        {var}`"char"` enables all server rules including spacing rules.

        Sets {var}`SymbolsPreproc`.
      '';
    };

    symbolsPreprocFiles = mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "gender-neutral.dic"
        "font-variants.dic"
        "symbols.dic"
        "emojis.dic"
        "orca.dic"
        "orca-chars.dic"
      ];
      description = ''
        Preprocessing dictionary files loaded by the server for symbol
        substitution, in order from most to least specific localization.

        Sets {var}`SymbolsPreprocFile`.
      '';
    };

    audioOutputMethod = mkOption {
      type = lib.types.enum [
        "pulse"
        "alsa"
        "oss"
        "pipewire"
        "libao"
      ];
      default = "libao";
      description = ''
        Audio output system used at runtime.
        Sets {var}`AudioOutputMethod`.
        Overrides {var}`speechd` to include the speciffic backend.
      '';
    };

    defaultModule = mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Name of the default output module. Must match a name from an
        {var}`AddModule` directive.

        Sets {var}`DefaultModule`.
      '';
      example = "espeak-ng";
    };

    extraConfig = mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        System wide configuration file for Speech Dispatcher. This will be used if no user configuration file is found.
      '';
      example = ''
        AddModule "module_name" "module_binary" "module_config"
      '';
    };

    modules = mkOption {
      description = ''
        Predefined interfaces for Speech Dispatcher output modules.
      '';
      type = lib.types.submodule {

        # freeformType lets unknown attrs (old raw strings) pass through
        # so we can catch them in config and warn, rather than error at eval
        freeformType = lib.types.attrsOf (lib.types.either lib.types.lines lib.types.anything);
        options = lib.mapAttrs (
          name: mod:
          mkOption {
            type = mod.type;
            default = { };
            visible = mod.visible or true;
            description = "Configuration for the ${mod.displayName} Speech Dispatcher output module.";
          }
        ) outputModules;
      };
    };

    extraModules = mkOption {
      type = with lib.types; submodule { freeformType = attrsOf lines; };
      default = { };
      description = ''
        Extra configuration files of output modules.
      '';
      example = {
        # TODO find a better example
        llia-generic = ''
          AddVoice        "cs"  "male1"   "kadlec"
          AddVoice        "sk"  "male1"   "bob"
        '';
      };
    };

    extraClients = mkOption {
      type = with lib.types; submodule { freeformType = attrsOf lines; };
      default = { };
      description = ''
        Client specific configuration.
      '';
      example = {
        emacs = ''
          BeginClient "emacs:*"
          # Example:
          #   DefaultPunctuationMode "some"
          EndClient
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions =
      lib.concatLists (
        lib.mapAttrsToList (
          name: mod:
          map (confFile: {
            assertion =
              !(cfg.modules.${name}.enable && cfg.extraModules ? "${lib.removeSuffix ".conf" confFile}");
            message = ''
              services.speechd.modules.${name} and services.speechd.extraModules."${lib.removeSuffix ".conf" confFile}"
              both configure speech-dispatcher/modules/${confFile}.
              Remove one of them.
            '';
          }) mod.confFiles
        ) outputModules
      )
      ++ [
        {
          assertion =
            cfg.defaultModule == null
            || lib.any (
              name:
              cfg.modules.${name}.enable
              && lib.any (f: lib.removeSuffix ".conf" f == cfg.defaultModule) outputModules.${name}.confFiles
            ) (lib.attrNames outputModules)
            || cfg.extraModules ? "${cfg.defaultModule}";
          message = ''
            services.speechd.defaultModule is set to "${cfg.defaultModule}" but no
            enabled module with that name was found.
          '';
        }

        {
          assertion = !(lib.hasInfix "LogLevel" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains a LogLevel directive.
            Use services.speechd.logLevel instead.
          '';
        }

        {
          assertion = !(lib.hasInfix "LogDir" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains a LogDir directive.
            Use services.speechd.logDir instead.
          '';
        }

        {
          assertion = !(lib.hasInfix "DefaultVolume" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains a DefaultVolume directive.
            Use services.speechd.defaultVolume instead.
          '';
        }

        {
          assertion = !(lib.hasInfix "SymbolsPreproc" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains a SymbolsPreproc directive.
            Use services.speechd.symbolsPreproc instead.
          '';
        }

        {
          assertion = !(lib.hasInfix "AudioOutputMethod" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains an AudioOutputMethod directive.
            Use services.speechd.audioOutputMethod instead.
          '';
        }

        {
          assertion = !(lib.hasInfix "DefaultModule" cfg.extraConfig);
          message = ''
            services.speechd.extraConfig contains a DefaultModule directive.
            Use services.speechd.defaultModule instead.
          '';
        }
      ];

    environment = {
      systemPackages = [
        (cfg.package.override {
          withEspeak = cfg.modules.espeakNg.enable;
          withPico = cfg.modules.pico.enable;
          withFlite = cfg.modules.flite.enable;
          # Use the defined audio output backend
          withPulse = lib.elem cfg.audioOutputMethod [ "pulse" ];
          withLibao = lib.elem cfg.audioOutputMethod [ "libao" ];
          withAlsa = lib.elem cfg.audioOutputMethod [ "alsa" ];
          withOss = lib.elem cfg.audioOutputMethod [ "oss" ];
          withPipewire = lib.elem cfg.audioOutputMethod [ "pipewire" ];
        })
      ];

      etc = {
        "speech-dispatcher/speechd.conf".text =
          cfg.extraConfig
          + ''
            LogLevel ${toString cfg.logLevel}
            LogDir "${cfg.logDir}"
            DefaultVolume ${toString cfg.defaultVolume}
            SymbolsPreproc "${cfg.symbolsPreproc}"
          ''
          + lib.concatMapStrings (file: ''
            SymbolsPreprocFile "${file}"
          '') cfg.symbolsPreprocFiles
          + ''
            AudioOutputMethod "${toString cfg.audioOutputMethod}"
          ''
          + lib.concatStrings (
            lib.mapAttrsToList (
              name: mod: lib.optionalString cfg.modules.${name}.enable mod.generateAddModule
            ) outputModules
          )
          + lib.optionalString (cfg.defaultModule != null) ''
            DefaultModule ${toString cfg.defaultModule}
          ''
          + ''
            Include "clients/*.conf"
          '';
      }
      // (mapAttrs' (name: value: {
        name = "speech-dispatcher/modules/${name}.conf";
        value.text = value;
      }) cfg.extraModules)
      // (mapAttrs' (name: value: {
        name = "speech-dispatcher/clients/${name}.conf";
        value.text = value;
      }) cfg.extraClients)
      // lib.mergeAttrsList (
        lib.mapAttrsToList (name: mod: mod.generateEtc cfg.modules.${name}) outputModules
      );
    };

    systemd.packages = [ cfg.package ];
    # have to set `wantedBy` since `systemd.packages` ignores `[Install]`
    systemd.user.sockets.speech-dispatcher.wantedBy = [ "sockets.target" ];

  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
