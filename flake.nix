
{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    # grub2-themes.url = "github:vinceliuice/grub2-themes";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

     stylix.url = "github:danth/stylix";

};


  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    grub2-themes,
    hyprland,
    nix-flatpak,
    stylix,
    ...
  } @ inputs: let
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
  in {
  
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;


    nixosConfigurations = {
      nixDesk = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs systems;
          inherit pkgs-unstable;
          };
        modules = [
          # > Our main nixos configuration file <
          ./hosts/nixDesk/configuration.nix
          # grub2-themes.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.rasmus = import ./home/rasmus/nixDesk/home.nix;
              extraSpecialArgs = {
                 inherit inputs outputs;
                 inherit pkgs-unstable;
              };
            };
          }
        ];
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


    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixLap = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main nixos configuration file <
          ./hosts/nixLap/configuration.nix
          grub2-themes.nixosModules.default
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "rasmus@nixLap" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs outputs;
          inherit pkgs-unstable;
        };
        modules = [
          # > Our main home-manager configuration file <
          ./hosts/nixLap/home.nix
        ];
      };
    };
  };
}
