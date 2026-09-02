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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Bar for hyprland
    ags.url = "github:Aylur/ags";

    # Secrets
    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    stylix = {
      # url = "github:danth/stylix";
      url = "github:danth/stylix/release-26.05";
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

    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "gitlab:doronbehar/nix-matlab";
      url = "/home/rasmus/Downloads/nix-matlab";
    };

    # Flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    let
      inherit (self) outputs;

      overlayPkgs = import ./pkgs;

      systemSettings = {
        timezone = "Europe/Copenhagen";
        locale = "en_DK.UTF-8";
      };

      userSettings = {
        username = "rasmus";
        de = {
          hyprland = false;
          kde = true;
          gnome = false;
          cosmic = true;
          console = true;
        };
        editor = "emacs";
        style-color = "catppuccin-mocha";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.treefmt-nix.flakeModule
          inputs.git-hooks-nix.flakeModule
        ];

        systems = [
          # "aarch64-linux"
          "x86_64-linux"
        ];

        # Everything here is auto-namespaced per system: config.packages,
        # config.checks, config.formatter, etc. all fan out for each entry
        # in `systems` above without you writing forAllSystems by hand.
        perSystem =
          {
            system,
            pkgs,
            lib,
            ...
          }:
          let
            pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
          in
          {

            treefmt = {
              programs = {
                nixfmt = {
                  enable = true;
                  package = pkgs.nixfmt;
                  indent = 2;
                };

                keep-sorted = {
                  enable = true;
                };
              };
            };

            pre-commit = {
              check.enable = true;
              settings = {
                enable = true;
                hooks = {
                  treefmt = {
                    enable = true;
                  };
                };
              };
            };

            # Replaces the manual `pkgsFor` you had scattered across
            # packages/legacyPackages/checks/formatter - one overlay
            # application, shared by every perSystem output below.
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                overlayPkgs
                (final: _prev: {
                  pnpm_10_29_2 = final.pnpm_10;
                  ccextractor = pkgs-unstable.ccextractor;
                })
              ];
            };

            # Same filter you had before: only flat derivations are valid
            # under packages.<system>.
            packages = inputs.nixpkgs.lib.filterAttrs (_: inputs.nixpkgs.lib.isDerivation) (
              overlayPkgs pkgs pkgs
            );

            # Full pkgs with the overlay applied, same as before - nested
            # sets like piperTtsVoices work the same as in plain nixpkgs.
            legacyPackages = pkgs;

            checks =
              let
                lib = inputs.nixpkgs.lib;

                testTree = import ./tests {
                  inherit pkgs;
                  inherit self;
                };

                flattenTests =
                  prefix: tree:
                  lib.concatMapAttrs (
                    name: value:
                    let
                      path = if prefix == "" then name else "${prefix}-${name}";
                    in
                    if lib.isDerivation value then { ${path} = value; } else flattenTests path value
                  ) tree;

                docChecks = lib.mapAttrs' (
                  name: module:
                  lib.nameValuePair "docs-${name}" (
                    (pkgs.nixosOptionsDoc {
                      options =
                        (inputs.nixpkgs.lib.nixosSystem {
                          inherit system;
                          modules = [
                            { nixpkgs.overlays = [ overlayPkgs ]; }
                            module
                          ];
                        }).options;
                    }).optionsCommonMark
                  )
                ) self.nixosModules;
              in
              (flattenTests "" testTree) // docChecks // inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
          };

        # Attrs that are NOT per-system: nixosConfigurations, overlays,
        # exported modules, deploy-rs nodes. These land directly on the
        # flake's own output set, same as your old top-level `outputs`.
        flake = {
          overlays = import ./overlays { inherit inputs; };
          nixosModules = import ./modules/nixos;
          homeManagerModules = import ./modules/home-manager;

          nixosConfigurations =
            let
              commonModules = [
                {
                  nixpkgs.overlays = [
                    overlayPkgs
                    inputs.nix-matlab.overlay
                    (final: _prev: {
                      pnpm_10_29_2 = final.pnpm_10;
                      ccextractor = inputs.nixpkgs-unstable.legacyPackages.${final.system}.ccextractor;
                    })
                  ];
                }
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.stylix.nixosModules.stylix
                inputs.nix-index-database.nixosModules.nix-index
              ]
              ++ (builtins.attrValues self.nixosModules);

              mkHost =
                {
                  hostName,
                  extraModules ? [ ],
                }:
                inputs.nixpkgs.lib.nixosSystem {
                  specialArgs = {
                    inherit inputs outputs;
                    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
                    inherit systemSettings;
                    inherit userSettings;
                  };
                  modules =
                    commonModules
                    ++ extraModules
                    ++ [
                      { nixpkgs.overlays = [ overlayPkgs ]; }
                      inputs.home-manager.nixosModules.home-manager
                      ./hosts/${hostName}/configuration.nix
                      {
                        home-manager = {
                          useGlobalPkgs = true;
                          useUserPackages = true;
                          backupFileExtension = "bkp";
                          sharedModules = [
                            inputs.plasma-manager.homeModules.plasma-manager
                            inputs.cosmic-manager.homeManagerModules.cosmic-manager
                            inputs.nvf.homeManagerModules.default
                          ];
                          users.${userSettings.username} = import ./home/${userSettings.username}/${hostName}/home.nix;
                          extraSpecialArgs = {
                            inherit inputs outputs;
                            pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
                            inherit systemSettings;
                            inherit userSettings;
                          };
                        };
                      }
                    ];
                };
            in
            {
              nixDesk = mkHost { hostName = "nixDesk"; };
              nixLap = mkHost {
                hostName = "nixLap";
                # extraModules = [ "${inputs.nixos-hardware}/lenovo/legion/15ich" ];
              };
              nixServer = mkHost { hostName = "nixServer"; };
            };

          deploy.nodes.nixServer = {
            hostname = "nixServer"; # Tailscale MagicDNS name
            sshUser = "rasmus";
            interactiveSudo = true;
            profiles.system = {
              user = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixServer;
            };
          };
        };
      }
    );
}
