{
  config,
  lib,
  pkgs,
  ...
}:
let
  systemFlakeRebuild = pkgs.writeShellApplication {
    name = "system-rebuild";
    runtimeInputs = [ pkgs.nh ];
    text = ''
      if [ -n "''${1:-}" ]; then
        HOST=$1
      else
        HOST=$(hostname)
      fi

      systemd-run --user --scope --collect -- \
        nh os switch . --hostname "$HOST" -- --impure --keep-going
    '';
  };

  systemflakerebuildlocal = pkgs.writeShellApplication {
    name = "system-rebuild-local";
    runtimeInputs = [ pkgs.nh ];
    text = ''
      if [ -n "''${1:-}" ]; then
        HOST=$1
      else
        HOST=$(hostname)
      fi

      NIXPKGS_PATH="''${NIXPKGS_PATH:-/home/rasmus/Projects/nix/nixpkgs}"
      HOME_MANAGER_PATH="''${HOME_MANAGER_PATH:-/home/rasmus/Projects/nix/home-manager}"

      nh os switch . --hostname "$HOST" -- --impure \
        --override-input nixpkgs "path:$NIXPKGS_PATH" \
        --override-input home-manager "path:$HOME_MANAGER_PATH" \
        --override-input stylix "github:danth/stylix"
    '';
  };

  systemFlakeRebuildTrace = pkgs.writeShellApplication {
    name = "system-rebuild-trace";
    runtimeInputs = [ pkgs.nh ];
    text = ''
      if [ -n "''${1:-}" ]; then
        HOST=$1
      else
        HOST=$(hostname)
      fi

      systemd-run --user --scope --collect -- \
        nh os switch . --hostname "$HOST" -- --impure --show-trace
    '';
  };

  systemFlakeRebuildBoot = pkgs.writeShellApplication {
    name = "system-boot";
    runtimeInputs = [ pkgs.nh ];
    text = ''
      if [ -n "''${1:-}" ]; then
        HOST=$1
      else
        HOST=$(hostname)
      fi

      systemd-run --user --scope --collect -- \
        nh os boot . --hostname "$HOST" -- --impure --keep-going
    '';
  };
in
{
  environment.systemPackages = [
    systemFlakeRebuild
    systemflakerebuildlocal
    systemFlakeRebuildTrace
    systemFlakeRebuildBoot
  ];
}
