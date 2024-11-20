SOPS_FILE := "../nix-secrets/secrets.yaml"

# default recipe to display help information
default:
  @just --list

rebuild-pre: update-nix-secrets
  git add **

rebuild-post:
  just check-sops

# This is if home-manager is standalone
rebuild-user: rebuild-pre
  scripts/user-flake-rebuild.sh

# Add --option eval-cache false if you end up caching a failure you can't get around
rebuild: rebuild-pre
  scripts/system-flake-rebuild.sh
  # scripts/user-flake-rebuild.sh 

# Requires sops to be running and you must have reboot after initial rebuild
rebuild-full: rebuild-pre && rebuild-post
  scripts/system-flake-rebuild.sh

# Requires sops to be running and you must have reboot after initial rebuild
rebuild-trace: rebuild-pre && rebuild-post
  scripts/system-flake-rebuild-trace.sh


# Rebuilds boot from flake
rebuild-boot: rebuild-pre && rebuild-post
  scripts/system-flake-rebuild-boot.sh

update:
  nix flake update

rebuild-update: update && rebuild

diff:
  git diff ':!flake.lock'

sops:
  echo "Editing {{SOPS_FILE}}"
  nix-shell -p sops --run "SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops {{SOPS_FILE}}"

age-key:
  nix-shell -p age --run "age-keygen"

rekey:
  cd ../nix-secrets && (\
    sops updatekeys -y secrets.yaml && \
    (pre-commit run --all-files || true) && \
    git add -u && (git commit -m "chore: rekey" || true) && git push \
  )
check-sops:
  scripts/check-sops.sh

update-nix-secrets:
  (cd ../nix-secrets && git fetch && git rebase) || true
  nix flake lock --update-input nix-secrets

update-doom:
  just rebuild
  ~/.config/emacs/bin/doom sync
