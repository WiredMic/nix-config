{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

            # Bar for hyprland
    ags.url = "github:Aylur/ags";

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    stylix = {
      # url = "github:danth/stylix";
      # url = "github:danth/stylix/release-25.11";
      url = "github:danth/stylix/cfde343ff369c8aa898f263ed3dad8c5eb095491";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # waveforms.url = "github:liff/waveforms-flake";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Neovim
    nvf.url = "github:notashelf/nvf";

    # Emacs
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      cosmic-manager,
      plasma-manager,
      nix-flatpak,
      stylix,
      ags,
      nixos-hardware,
      # nix-ld,
      nix-index-database,
      sops-nix,
      # waveforms,
      nvf,
      emacs-overlay,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        # "aarch64-linux"
        "x86_64-linux"
      ];

      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      systemSettings = {
        system = "x86_64-linux";
        # host = "nixLap";
        timezone = "Europe/Copenhagen";
        locale = "en_DK.UTF-8";
      };

      userSettings = {
        username = "rasmus";
        de = {
          hyprland = true;
          kde = true;
          gnome = false;
          cosmic = true;
          console = true;
        };
        # deType = "wayland"; # x11 vs wayland
        # editor = "emacsclient -c -a ''";
        editor = "emacs";
        style-color = "catppuccin-mocha";
      };

    in
    {

      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${systemSettings.system});

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        nixDesk = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            # grub2-themes.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager

            # Our main nixos configuration file <
            ./hosts/nixDesk/configuration.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp";
                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                  cosmic-manager.homeManagerModules.cosmic-manager
                  nvf.homeManagerModules.default
                ];
                users.${userSettings.username} = import ./home/${userSettings.username}/nixDesk/home.nix;
                extraSpecialArgs = {
                  inherit inputs outputs;
                  inherit pkgs-unstable;
                  inherit systemSettings;
                  inherit userSettings;
                };
              };
            }
          ];
        };
      };

      nixosConfigurations = {
        nixLap = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.nix-index
            "${nixos-hardware}/lenovo/legion/15ich"

            home-manager.nixosModules.home-manager

            # Our main nixos configuration file <
            ./hosts/nixLap/configuration.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp";
                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                  cosmic-manager.homeManagerModules.cosmic-manager
                  nvf.homeManagerModules.default
                ];
                users.${userSettings.username} = import ./home/${userSettings.username}/nixLap/home.nix;
                extraSpecialArgs = {
                  inherit inputs outputs;
                  inherit pkgs-unstable;
                  inherit systemSettings;
                  inherit userSettings;
                };
              };
            }
          ];
        };
      };

      nixosConfigurations = {
        nixServer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            # Must be here for the other configs
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager

            # Our main nixos configuration file
            ./hosts/nixServer/configuration.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp";
                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                  cosmic-manager.homeManagerModules.cosmic-manager
                  nvf.homeManagerModules.default
                ];
                users.${userSettings.username} = import ./home/${userSettings.username}/nixServer/home.nix;
                extraSpecialArgs = {
                  inherit inputs outputs;
                  inherit pkgs-unstable;
                  inherit systemSettings;
                  inherit userSettings;
                };
              };
            }
          ];
        };
      };
    };
}
