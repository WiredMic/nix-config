{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";

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
      url = "github:danth/stylix";
      # url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # waveforms.url = "github:liff/waveforms-flake";

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Neovim
    nvf = {
      url = "github:notashelf/nvf";
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
      treefmt-nix,
      ags,
      nixos-hardware,
      # nix-ld,
      nix-index-database,
      sops-nix,
      # waveforms,
      nvf,
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
          cosmic = true;
          console = false;
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
      packages = forAllSystems (
        system:
        let
          pkgsFor = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs pkgsFor pkgsFor # overlay form: final: prev:
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      formatter = forAllSystems (
        system:
        (treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix).config.build.wrapper
      );

      nixosConfigurations = {
        nixDesk = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            { nixpkgs.overlays = [ (import ./pkgs) ]; }
            nix-flatpak.nixosModules.nix-flatpak
            stylix.nixosModules.stylix

            # nix-ld.nixosModules.nix-ld
            nix-index-database.nixosModules.nix-index

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

        nixLap = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            { nixpkgs.overlays = [ (import ./pkgs) ]; }
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

        nixServer = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            # Must be here for the other configs
            { nixpkgs.overlays = [ (import ./pkgs) ]; }
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
