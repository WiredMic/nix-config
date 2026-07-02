# TODO Change speechd -> speechd2

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speechd2;

  # TODO: Remove this in 27.05
  legacyStringModules = lib.filterAttrs (name: value: lib.isString value) cfg.modules;

  inherit (lib)
    mapAttrs'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    ;

  mkSimpleGenerateEtc =
    name: confFile: modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/${name}.conf".text =
        builtins.replaceStrings
          [ "Debug 0" "Debug 1" ]
          [ "Debug ${lib.toString modCfg.debug}" "Debug ${lib.toString modCfg.debug}" ]
          (builtins.readFile "${cfg.package}/etc/speech-dispatcher/modules/${confFile}")
        + "\n"
        + modCfg.extraConfig;
    };

  mkSimpleAddModule = binary: name: ''AddModule "${name}" "${binary}" "${name}.conf"'';

  outputModules =
    let
      mods =
        lib.mapAttrs
          (
            name: filename:
            import ./speechd-modules/${filename}.nix {
              inherit lib pkgs;
              inherit (lib) mkPackageOption mkEnableOption mkOption;
            }
          )
          {
            # keep-sorted start case=no
            baratinoo = "baratinoo";
            cicero = "cicero";
            dtk = "dtk";
            epos = "epos";
            espeakNg = "espeak-ng";
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
      binaryFor =
        mod: modCfg:
        let
          b = mod.binary or "sd_generic";
        in
        if lib.isFunction b then b modCfg else b;
    in
    lib.mapAttrs (
      name: mod:
      mod
      // {
        generateEtc = mod.generateEtc or (mkSimpleGenerateEtc name mod.confFile);
        generateAddModule =
          mod.generateAddModule or (modCfg: mkSimpleAddModule (binaryFor mod modCfg) name);
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
        # "oss"
        # "nas"
        "pipewire"
        "libao"
      ];
      default = "libao";
      description = ''
        Audio output system used at runtime.
        Sets {var}`AudioOutputMethod`.
        Overrides {var}`speechd` to include the specific backend.
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

    finalPackage = mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = ''
        The Speech Dispatcher package used by the module.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.speechd2.finalPackage = (
      cfg.package.override {
        withEspeak = cfg.modules.espeakNg.enable;
        espeak = cfg.modules.espeakNg.package;
        withPico = cfg.modules.pico.enable;
        picotts = cfg.modules.pico.package;
        withFlite = cfg.modules.flite.enable;
        flite = cfg.modules.flite.package;
        # Use the defined audio output backend
        withPulse = lib.elem cfg.audioOutputMethod [ "pulse" ];
        withLibao = lib.elem cfg.audioOutputMethod [ "libao" ];
        withAlsa = lib.elem cfg.audioOutputMethod [ "alsa" ];
        withOss = lib.elem cfg.audioOutputMethod [ "oss" ];
        withPipewire = lib.elem cfg.audioOutputMethod [ "pipewire" ];
      }
    );

    # TODO: Remove this in 27.05
    services.speechd2.extraModules = legacyStringModules;

    assertions =
      # The user cannot add a module in `extraModules` that is already defined in `modules`
      lib.concatLists (
        lib.mapAttrsToList (name: mod: [
          {
            assertion =
              !(cfg.modules.${name}.enable && cfg.extraModules ? "${lib.removeSuffix ".conf" mod.confFile}");
            message = ''
              services.speechd.modules.${name} and services.speechd.extraModules."${lib.removeSuffix ".conf" mod.confFile}"
              both configure speech-dispatcher/modules/${mod.confFile}.
              Remove one of them.
            '';
          }
        ]) outputModules
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
            || (outputModules ? ${cfg.defaultModule} && cfg.modules.${cfg.defaultModule}.enable)
            || cfg.extraModules ? "${cfg.defaultModule}";
          message = ''
            services.speechd2.defaultModule is set to "${toString cfg.defaultModule}" but it
            does not match the attribute name of an enabled module under
            services.speechd2.modules, nor a key in services.speechd2.extraModules.
          '';
        }
      ]
      ++ [
        # TODO: Remove this assertion in 27.05
        {
          assertion = lib.all (
            name: builtins.elem name (lib.attrNames outputModules) || lib.isString cfg.modules.${name}
          ) (lib.attrNames cfg.modules);
          message = ''
            services.speechd2.modules contains unrecognized backend name(s): ${
              toString (
                lib.filter (
                  name: !(builtins.elem name (lib.attrNames outputModules) || lib.isString cfg.modules.${name})
                ) (lib.attrNames cfg.modules)
              )
            }.
            Valid backend names are: ${toString (lib.attrNames outputModules)}.
          '';
        }
      ]
      ++ [
        # TODO: Remove this assertion in 27.05
        {
          assertion = lib.all (name: !(cfg.extraModules ? ${name})) (lib.attrNames legacyStringModules);
          message = ''
            The following `services.speechd2.modules` entries are raw configuration
            strings that collide with a same-named `services.speechd2.extraModules`
            entry: ${
              toString (lib.filter (name: cfg.extraModules ? ${name}) (lib.attrNames legacyStringModules))
            }.
            Move everything to `services.speechd2.extraModules.<name>`.
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

    # TODO: Remove in 27.05 along with freeformType on `modules`.
    warnings = lib.mapAttrsToList (name: _: ''
      The option `services.speechd2.modules.${name}` is set as a raw configuration string.
      Raw configurations have moved to `services.speechd2.extraModules.${name}` instead.
    '') legacyStringModules;

    environment = {
      systemPackages = [
        cfg.finalPackage
      ];

      etc = {
        "speech-dispatcher/speechd.conf".text =
          cfg.extraConfig
          + "\n"
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
              name: mod: lib.optionalString cfg.modules.${name}.enable (mod.generateAddModule cfg.modules.${name})
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

    # Ensure that the log directory is created
    systemd.tmpfiles.rules = lib.optional (
      cfg.logDir != "default" && cfg.logDir != "stdout"
    ) "d ${cfg.logDir} 1777 - - - -";

    systemd.packages = [ cfg.finalPackage ];
    # have to set `wantedBy` since `systemd.packages` ignores `[Install]`
    systemd.user.sockets.speech-dispatcher.wantedBy = [ "sockets.target" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
