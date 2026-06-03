{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ollama;
in
{
  options.services.ollama = {
    loadModels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      apply = builtins.filter (model: model != "");
      default = [ ];
      example = [
        "dolphin3"
        "gemma3"
        "gemma3:27b"
        "deepseek-r1:latest"
        "deepseek-r1:1.5b"
      ];
      description = ''
        Download these models using `ollama pull` as soon as `ollama.service` has started.

        This creates a systemd unit `ollama-model-loader.service`.
        Use `services.ollama.syncModels` to automatically remove any models not currently declared here.

        Search for models of your choice from: <https://ollama.com/library>
      '';
    };
    syncModels = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Synchronize all currently installed models with those declared in `services.ollama.loadModels`,
        removing any models that are installed but not currently declared there.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && (cfg.loadModels != [ ] || cfg.syncModels)) {
    systemd.user.services.ollama-model-loader = {
      Unit = {
        Description = "Download ollama models";
        After = [ "ollama.service" ];
        BindsTo = [ "ollama.service" ];
      };
      Service = {
        Type = "exec";
        RemainAfterExit = true;
        Environment = config.systemd.user.services.ollama.Service.Environment;
        ExecStart =
          let
            ollama = lib.getExe cfg.package;
            parallel = lib.getExe pkgs.parallel;
            awk = lib.getExe pkgs.gawk;
            sed = lib.getExe pkgs.gnused;

            declaredModelsRegex = lib.pipe cfg.loadModels [
              (map lib.escapeRegex)
              (lib.concatStringsSep "|")
              (lib.escape [ "/" ])
              lib.escapeShellArg
            ];

            script = pkgs.writeShellScript "ollama-model-loader" ''
              ${lib.optionalString cfg.syncModels ''
                installed=$('${ollama}' list | '${awk}' 'NR > 1 {print $1}')
                ${
                  if (cfg.loadModels != [ ]) then
                    ''
                      echo "declared models regex: ${declaredModelsRegex}"
                      undeclared=$(echo "$installed" | '${sed}' -E /${declaredModelsRegex}/d)
                    ''
                  else
                    ''
                      undeclared="$installed"
                    ''
                }
                if [ -n "$undeclared" ]; then
                  echo "removing: $undeclared"
                  '${ollama}' rm $undeclared
                fi
              ''}

              '${parallel}' --tag '${ollama}' pull ::: ${lib.escapeShellArgs cfg.loadModels}
            '';
          in
          "${script}";
        Restart = "on-failure";
        RestartSec = "1s";
        RestartMaxDelaySec = "2h";
        RestartSteps = "10";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
