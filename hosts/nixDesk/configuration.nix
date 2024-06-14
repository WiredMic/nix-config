# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
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
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

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
 

  # Desktop environment
  de.kde.enable = true;
  de.hyprland.enable = true;
  my.sddm.enable = true;

  networking = {
    # Enable networking
    networkmanager.enable = true;

    # hostname
    hostName = "nixDesk";

    firewall = { 
      enable = true;
    }; 
  };
  
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
  time.timeZone = "Europe/Copenhagen";

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # 
    # Configure keymap in X11
    xkb = {
      layout = "us";
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
    
    # network share maybe 
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio
    kdePackages.kdenetwork-filesharing
    samba
    home-manager
    
    wtype # does not work on kde or gnome
    wev
    miru
    davinci-resolve
    just
    fastfetch
    nmap

    wl-clipboard
    wl-clipboard-x11
  ];
 
  # https://github.com/gmodena/nix-flatpak
  services.flatpak.enable = true;

  # services.flatpak.remotes = lib.mkOptionDefault [{
  #   name = "flathub-beta";
  #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  # }];

  services.flatpak.packages = [
    { appId = "org.mozilla.Thunderbird"; origin = "flathub";  }
    { appId = "com.spotify.Client"; origin = "flathub";  }
    { appId = "com.usebottles.bottles"; origin = "flathub";  }
  ];

  # Software from optional

  my.games.enable = true;
  my.emulation.enable = true;

  # Help to use the PC
  my.tts.enable = true; # TODO piper
  programs.ydotool.enable = true; # TODO get it to work
  # TODO Spellcheck

  # Cloud storage
  my.onedrive.enable = true;

  # theming stylix
  # stylix.enable = true;
  stylix.image = ../common/optional/stylix/hong-kong-night.jpg;
  my.stylix.enable = true;

  # theme gtk
  programs.dconf.enable = true;

  user.rasmus.enable = true;

  programs.ssh.startAgent = true;
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
  ];
  
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}






  

