SOPS_FILE := "../nix-secrets/secrets.yaml"

# default recipe to display help information
default:
    @just --list

rebuild-pre: update-nix-secrets
    git add -A
    sudo nix flake check
    nix fmt

rebuild-post:
    just check-sops

# Add --option eval-cache false if you end up caching a failure you can't get around
rebuild: rebuild-pre
    system-rebuild

nixpkgs_path := "/home/rasmus/Projects/nix/nixpkgs"
home_manager_path := "/home/rasmus/Projects/nix/home-manager"

# Rebuild against local nixpkgs/home-manager checkouts
rebuild-local nixpkgs=nixpkgs_path home-manager=home_manager_path:
    git add -A
    NIXPKGS_PATH={{nixpkgs}} HOME_MANAGER_PATH={{home-manager}} system-rebuild-local

# Requires sops to be running and you must have reboot after initial rebuild
rebuild-trace: rebuild-pre && rebuild-post
    system-rebuild-trace

# Rebuilds boot from flake
rebuild-boot: rebuild-pre && rebuild-post
   system-boot 

update:
    nix flake update

rebuild-update: update && rebuild

update-nix-secrets:
    (cd ../nix-secrets && git fetch && git rebase) || true
    nix flake update nix-secrets
