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

    ./big_picture.nix
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

      # https://github.com/NixOS/nixpkgs/issues/514113
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
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
    experimental-features = [
      "nix-command flakes"
      "auto-allocate-uids"
      "cgroups"
    ];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # Build with one core less than max
    cores = 6;
    max-jobs = 3;

    auto-allocate-uids = true;
    extra-system-features = [ "uid-range" ];
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

  my.boot.efi.enable = true;
  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  networking = {
    # Enable networking
    networkmanager.enable = true;

    # hostname
    hostName = "nixDesk";

    firewall = {
      enable = true;
    };
  };

  # Swap
  zramSwap = {
    enable = true;
    memoryPercent = 50; # compressed swap in RAM, ~50% of RAM as zram device
    priority = 10; # higher priority than disk swap, used first
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];

  # The ultimate Killer
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    enableSystemSlice = true;
  };

  # Amd GPU
  # https://nixos.wiki/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL
    ];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  # AMD CPU
  hardware.cpu.amd.updateMicrocode = true;

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    #
    # Configure keymap in X11
    xkb = {
      layout = "eu";
      variant = "";
    };
  };

  # Software

  environment.systemPackages = with pkgs; [
    git
    neovim
    firefox
    xclip
    tree
    gcc
    kdePackages.kdeconnect-kde
    ntfs3g

    # network share maybe
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio
    kdePackages.kdenetwork-filesharing
    samba
    home-manager

    pciutils
    nvme-cli
    usbutils
    dmidecode

    wtype # does not work on kde or gnome
    wev
    just
    nmap
    file
    jq

    fastfetch
    gnome-system-monitor

    # icons
    papirus-icon-theme

    wl-clipboard
    wl-clipboard-x11

    wineWow64Packages.waylandFull

    sshfs

    nh
    nix-index
    freenet
    lightburn

    sshfs
    kdePackages.okular

    drawy

    element-desktop
  ];

  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;

  # services.flatpak.remotes = lib.mkOptionDefault [{
  #   name = "flathub-beta";
  #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  # }];

  services.flatpak.packages = [
    {
      appId = "com.spotify.Client";
      origin = "flathub";
    }
    {
      appId = "com.usebottles.bottles";
      origin = "flathub";
    }
    {
      appId = "com.github.tchx84.Flatseal";
      origin = "flathub";
    }
  ];

  # Software from optional

  my.games.enable = true;
  my.emulation.enable = true;

  # Help to use the PC
  my.tts.enable = true; # TODO piper
  # TODO Spellcheck

  my.thunar.enable = true;

  # theme gtk
  programs.dconf.enable = true;

  user.rasmus.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Depentencies
  services.gvfs.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  programs.kdeconnect.enable = true;

  virtualisation.waydroid.enable = true;

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  my.arduino.enable = true;

  services.freenet = {
    enable = true;
    nice = 10;
  };

  services.tailscale.enable = true;

  # # NFS NAS share
  # # https://nixos.wiki/wiki/NFS
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true; # needed for NFS

  systemd.services.tailscale-online = {
    description = "Wait for tailscale to have a working connection";
    after = [
      "tailscaled.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for i in $(seq 1 30); do
        ${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -e '.BackendState=="Running"' && exit 0
        sleep 1
      done
      exit 1
    '';
  };

  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "100.98.3.121:/mnt/ZPOOL0/share/";
      where = "/mnt/share";
      after = [ "tailscale-online.service" ];
      requires = [ "tailscale-online.service" ];
    }
  ];

  systemd.automounts = [
    {
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/share";
    }
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
