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
  nixos-hardware,
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
    max-jobs = 12;
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

  my.grub.efi.enable = true;

  networking = {
    # Enable networking
    networkmanager.enable = true;

    # hostname
    hostName = "nixLap";

    firewall = {
      enable = true;
    };
  };
  my.aau-wifi-cert.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL
    ];
  };

  # INTEL CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
        enable = "Source,Sink,Media,Socket";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
  services.blueman.enable = true;

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
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
    # wireplumber.extraConfig."10-bluez" = {
    #   "monitor.bluez.properties" = {
    #     "bluez5.enable-sbc-xq" = true;
    #     "bluez5.enable-msbc" = true;
    #     "bluez5.enable-hw-volume" = true;
    #     "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    #   };
    # };

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
    gparted

    # network share maybe s
    # TODO Samba does not work
    # it cannot connect to kpassd-server
    samba

    wtype # does not work on kde or gnome
    wev
    miru
    # calibre
    # davinci-resolve
    just
    fastfetch
    nmap
    gnome-system-monitor

    thunderbird

    wl-clipboard
    wl-clipboard-x11

    pciutils
    sshfs
    nfs-utils
    cifs-utils

    inkscape
    # kicad
    librepcb
    openscad

    kdePackages.okular
  ];

  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;

  # services.flatpak.remotes = lib.mkOptionDefault [{
  #   name = "flathub-beta";
  #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  # }];

  services.flatpak.packages = [
    # {
    #   appId = "org.mozilla.Thunderbird";
    #   origin = "flathub";
    # }
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
    {
      appId = "org.freecad.FreeCAD";
      origin = "flathub";
    }
  ];

  # Software from optional
  my.games.enable = true;
  my.emulation.enable = true;

  # Help to use the PC
  my.tts.enable = true; # TODO piper
  programs.ydotool.enable = true; # TODO get it to work
  # TODO Spellcheck

  # theme gtk
  programs.dconf.enable = true;

  user.rasmus.enable = true;

  programs.ssh.startAgent = true;

  my.distrobox.enable = true;

  my.arduino.enable = true;
  my.ollama.enable = true;

  services.solaar.enable = true;

  my.vpn.enable = true;

  my.thunar.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # Depentencies
  services.gvfs.enable = true; # For gtk file managers

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

  # Cloud
  my.onedrive.enable = true;
  my.syncthing.enable = true;

  # NFS NAS share
  # https://nixos.wiki/wiki/NFS
  services.rpcbind.enable = true; # needed for NFS

  services.udev.packages = with pkgs; [ platformio-core.udev ];

  programs.kdeconnect.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
