# TODO Change speechd -> speechd2

{
  config,
  lib,
  pkgs,
  sound-icons,
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

  mkSimpleGenerateEtc =
    confFiles: modCfg:
    lib.optionalAttrs modCfg.enable (
      lib.mergeAttrsList (
        map (confFile: {
          "speech-dispatcher/modules/${confFile}".text =
            builtins.replaceStrings
              [ "Debug 0" "Debug 1" ]
              [ "Debug ${lib.boolToInt modCfg.debug}" "Debug ${lib.boolToInt modCfg.debug}" ]
              (builtins.readFile "${cfg.package}/etc/speech-dispatcher/modules/${confFile}")
            + modCfg.extraConfig;
        }) confFiles
      )
    );

  mkSimpleAddModule =
    binary: confFile: ''AddModule "${lib.removeSuffix ".conf" confFile}" "${binary}" "${confFile}"'';

  outputModules =
    let
      mods = lib.mapAttrs (name: filename: import ./modules/${filename}.nix { inherit lib pkgs; }) {
        # keep-sorted start case=no
        baratinoo = "baratinoo";
        cicer = "cicero";
        dtk = "dtk";
        epos = "epos";
        espeakNg = "espeak-ng";
        espeakNgMbrola = "espeak-ng-mbrola";
        festival = "festival";
        flite = "flite";
        kali = "kali";
        lliaPhon = "llia-phon";
        mary = "mary";
        mimic3 = "mimic3";
        openjtalk = "openjtalk";
        pico = "pico";
        swift = "swift";
        voxin = "voxin";
        #keep-sorted end
      };
      binary = mod: mod.binary or "sd_generic";
    in
    lib.mapAttrs (
      name: mod:
      mod
      // {
        binary = binary mod;
        generateEtc = mod.generateEtc or (mkSimpleGenerateEtc mod.confFiles);
        generateAddModule =
          mod.generateAddModule
            or (lib.concatMapStrings (confFile: mkSimpleAddModule (binary mod) confFile + "\n") mod.confFiles);
      }
    ) mods;

in
{
  imports = [
    # TODO: Remove in 27.05
    (lib.mkRenamedOptionModule
      [ "services" "speechd2" "config" ]
      [ "services" "speechd2" "extraConfig" ]
    )
    # TODO: Remove in 27.05
    (lib.mkRenamedOptionModule
      [ "services" "speechd2" "clients" ]
      [ "services" "speechd2" "extraClients" ]
    )
  ];

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
        # TODO remove in 27.05
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
      # The user cannot add a module in `extraModules` that is already defined in `modules`
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
      # The user cannot set a variable in any `extraConfig` that has a named variable
      ++ lib.concatLists (
        lib.mapAttrsToList (
          name: mod: lib.optionals (mod ? assertions) (mod.assertions cfg.modules.${name})
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
      ]
      ++
        lib.mapAttrsToList
          (directive: option: {
            assertion = !(lib.hasInfix directive cfg.extraConfig);
            message = ''
              services.speechd.extraConfig contains a ${directive} directive.
              Use services.speechd.${option} instead.
            '';
          })
          {
            LogLevel = "logLevel";
            LogDir = "logDir";
            DefaultVolume = "defaultVolume";
            SymbolsPreproc = "symbolsPreproc";
            AudioOutputMethod = "audioOutputMethod";
            DefaultModule = "defaultModule";
          };

    # TODO remove the warnings after NixOS verions 27.05
    warnings = lib.optional (lib.any lib.isString (lib.attrValues (lib.removeAttrs cfg.modules (lib.attrNames outputModules)))) ''
      services.speechd.modules now contains typed backend options.
      Raw string values previously set under services.speechd.modules
      should be moved to services.speechd.extraModules instead.
    '';

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
