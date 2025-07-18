# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  systemSettings,
  userSettings,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import users
    ../common/users/users.nix

    # Import core common configs
    ../common/core/core.nix

    # Import optional common configs
    ../common/optional/optional.nix

  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
    (lib.filterAttrs (_: lib.isType "flake")) inputs
  );

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.loader.timeout = 0;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    # Enable networking
    networkmanager.enable = true;

    # hostname
    hostName = "nixServer";

    firewall = {
      enable = true;
    };
  };

  # Swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # AMD CPU
  hardware.cpu.amd.updateMicrocode = true;

  # AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.amdgpu = {
    initrd.enable = true;
    legacySupport.enable = true;
    opencl.enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  services.xserver = {
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Software
  services.cloud-init.network.enable = false;

  environment.systemPackages = with pkgs; [
    git
    neovim
    just
    nfs-utils
    lsof
    ncdu
    pciutils
    fastfetch
    ripgrep
    # top derivitives
    htop # cpu
    nvtopPackages.amd # gpu
  ];

  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  #   useRoutingFeatures = "server";
  #   authKeyFile = "/home/rasmus/tailscale.key";
  # };
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

  # Server
  # my.homepage.enable = true;

  my.jellyfin.enable = true;
  my.torrent.enable = true;

  my.calibre-web.enable = true;
  my.codex.enable = true;
  my.audiobookshelf.enable = true;

  my.blocky.enable = false; # this will not work because of rsolved

  # my.vaultwarden.enable = false;
  # my.nginx.enable = false;
  # my.nextcloud.enable = false;
  # my.immich.enable = true;

  # Cloud
  my.syncthing.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];

  # NFS NAS share
  # https://nixos.wiki/wiki/NFS
  services.rpcbind.enable = true; # needed for NFS

  # systemd.mounts = [{
  #   type = "nfs";
  #   mountConfig = { Options = "noatime"; };
  #   what = "192.168.86.35:/mnt/ZPOOL0/share";
  #   where = "/mnt/share";
  # }];
  #
  # systemd.automounts = [{
  #   wantedBy = [ "multi-user.target" ];
  #   automountConfig = { TimeoutIdleSec = "600"; };
  #   where = "/mnt/share";
  # }];

  # Software from optional

  # Users
  user.rasmus.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono

  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
