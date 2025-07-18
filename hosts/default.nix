{ inputs, userSettings, systemSettings, ... }:

let
    inherit (inputs) nixpkgs nixpkgs-stable home-manager stylix niri;

    lib = nixpkgs.lib;
in

    {
    betelgeuse = lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
            inherit inputs userSettings systemSettings;
            pkgs-stable = import nixpkgs-stable {
                system = "x86_64-linux";
                config.allowUnfree = true;
            };
            host = {
                name = "betelgeuse";
                monitors = {
                    tv = "HDMI-A-1";
                    left = "DP-3";
                    middle = "HDMI-A-2";
                    right = "DP-2";
                };
            };
        };
        modules = [
            ./betelgeuse
            ./configuration.nix

            home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
            }

            stylix.nixosModules.stylix
            niri.nixosModules.niri
        ];
    };

    vm = lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
            inherit inputs userSettings systemSettings;
            pkgs-stable = import nixpkgs-stable {
                system = "x86_64-linux";
                config.allowUnfree = true;
            };
            host = {
                name = "vm";
                monitors = {
                    main = "Virtual-1";
                };
            };
        };
        modules = [
            ./vm
            ./configuration.nix

            home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
            }

            stylix.nixosModules.stylix
            niri.nixosModules.niri
        ];
    };

    vm-arm = lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {
            inherit inputs userSettings systemSettings;
            pkgs-stable = import nixpkgs-stable {
                system = "aarch64-linux";
                config.allowUnfree = true;
            };
            host = {
                name = "vm-arm";
                monitors = {
                    main = "Virtual-1";
                };
            };
        };
        modules = [
            ./vm-arm
            ./configuration.nix

            home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
            }

            stylix.nixosModules.stylix
            niri.nixosModules.niri
        ];
    };
}




