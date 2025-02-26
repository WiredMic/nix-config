{ inputs, outputs, lib, config, pkgs, pkgs-unstable, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Core
    ../common/core/core.nix

    # Optional
    ../common/optional/optional.nix
  ];

  home = {
    username = "rasmus";
    homeDirectory = "/home/rasmus";
  };

  home.sessionVariables = {
    HISTFILE = "${config.xdg.stateHome}/bash/history";
  };

  nix.settings.use-xdg-base-directories = true; # moves .nix-* out of HOME

  home.packages = (with pkgs; [ ]) ++ (with pkgs-unstable;
    [
      # eza
    ]);

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.neovim.enable = true;

  home.sessionVariables = { EDITOR = lib.mkForce "nvim"; };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
