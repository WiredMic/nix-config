{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    # grub2-themes.url = "github:vinceliuice/grub2-themes";

    hyprland = { url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows =
        "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    nix-flatpak.url =
      "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    stylix.url = "github:danth/stylix";

    ags.url = "github:Aylur/ags";


    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager,
    # grub2-themes,
    hyprland, split-monitor-workspaces, nix-flatpak, stylix, nix-colors, ags, nixos-hardware
    , ... }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        # "aarch64-linux"
        "x86_64-linux"
      ];

      pkgs =
        nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      systemSettings = {
        system = "x86_64-linux";
        host = "nixLap";
        timezone = "Europe/Copenhagen";
        locale = "en_DK.UTF-8";
      };

      userSettings = {
        username = "rasmus";
        de = {
          hyprland = false;
          kde = true;
          gnome = false;
          cosmic = false;
        };
        deType = "wayland"; # x11 vs wayland
        editor = "emacsclient";
        style-color = "dracula";
      };

    in {

      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems
        (system: import ./pkgs nixpkgs.legacyPackages.${systemSettings.system});

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        ${systemSettings.host} = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit pkgs-unstable;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [
            # > Our main nixos configuration file <
            ./hosts/${systemSettings.host}/configuration.nix
            # grub2-themes.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            # nixos-hardware.nixosModules.lenovo-legion-15ich
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${userSettings.username} = import
                  ./home/${userSettings.username}/${systemSettings.host}/home.nix;
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

      # homeConfigurations = {
      #   "rasmus@nixDesk" = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = {
      #       inherit inputs outputs;
      #       inherit pkgs-unstable;
      #     };
      #     modules = [
      #       # > Our main home-manager configuration file <
      #       ./home/rasmus/nixDesk/home.nix
      #     ];
      #   };
      # };
}
