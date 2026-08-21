# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Import users
    ../common/users/users.nix

    # Import core common configs
    ../common/core/core.nix

    # Import optional common configs
    ../common/optional/optional.nix

    # cloud storage
    ./cloud/onedrive.nix
    ./cloud/syncthing.nix

  ];

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

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.extraPools = [ "ZPOOL0" ];
  boot.zfs.forceImportRoot = false;

  # boot loader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot";
        efiSysMountPoint = "/boot";
      }
      {
        devices = [ "nodev" ];
        path = "/boot2";
        efiSysMountPoint = "/boot2";
      }
    ];
  };

  # ZFS maintenance
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  # AMD CPU
  hardware.cpu.amd.updateMicrocode = true;

  # AMD GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  # WatchDog
  systemd.watchdog.runtimeTime = "30s";
  boot.kernelParams = [ "panic=10" ];

  # There was a transcoding GPU bug in the kernel
  # https://lwn.net/Articles/1081243/
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  networking = {
    # Enable networking
    networkmanager.enable = true;

    # hostname
    hostName = "nixServer";

    hostId = "8def9203";

    firewall = {
      enable = true;
      allowedTCPPorts = [
        2049
        111
        20048
      ];
      allowedUDPPorts = [
        2049
        111
        20048
      ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim
    wget
    just
    git
    fastfetch
    ripgrep
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # keys only, since you have one set
  };

  # Server
  my.homepage.enable = true;

  my.jellyfin.enable = true;
  my.torrent.enable = true;

  my.calibre-web.enable = true;
  my.calibre-server.enable = true;
  my.codex.enable = true;
  my.audiobookshelf.enable = true;

  my.blocky.enable = false; # this will not work because of rsolved

  # my.vaultwarden.enable = false;
  # my.nginx.enable = false;
  # my.nextcloud.enable = false;
  my.immich.enable = true;

  # Cloud
  server.syncthing.enable = true;
  my.vpn = {
    enable = true;
    role = "both";
  };
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];

  # Freenet
  services.freenet = {
    enable = true;
    nice = 10;
  };

  # NFS NAS share
  # https://nixos.wiki/wiki/NFS
  services.rpcbind.enable = true; # needed for NFS

  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/ZPOOL0/share 100.64.0.0/10(rw,sync,no_subtree_check)
    '';
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}
