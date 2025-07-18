{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # --Desktop Environments--
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    # Bar for hyprland
    ags.url = "github:Aylur/ags";

    # Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    stylix.url = "github:danth/stylix/release-25.05";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waveforms.url = "github:liff/waveforms-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      hyprland,
      split-monitor-workspaces,
      nix-flatpak,
      stylix,
      ags,
      nixos-hardware,
      # nix-ld,
      nix-index-database,
      solaar,
      sops-nix,
      waveforms,
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
          kde = false;
          gnome = false;
          cosmic = false;
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
            # > Our main nixos configuration file <
            ./hosts/nixDesk/configuration.nix
            # grub2-themes.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            # nix-ld.nixosModules.nix-ld
            solaar.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp";
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
            # > Our main nixos configuration file <
            ./hosts/nixLap/configuration.nix
            # grub2-themes.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            # nix-ld.nixosModules.nix-ld
            nix-index-database.nixosModules.nix-index
            solaar.nixosModules.default
            # nixos-hardware.nixosModules.lenovo-legion-15ich
            "${nixos-hardware}/lenovo/legion/15ich"
            waveforms.nixosModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp2";
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
            stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            # > Our main nixos configuration file <
            ./hosts/nixServer/configuration.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bkp";
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
