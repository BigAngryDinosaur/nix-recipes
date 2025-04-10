{ inputs, pkgs-stable, userSettings, systemSettings, ... }:

let
    inherit (systemSettings) system;
    inherit (inputs) nixpkgs home-manager stylix niri;

	lib = nixpkgs.lib;
in

{
	betelgeuse = lib.nixosSystem rec {
        inherit system;
		specialArgs = {
			inherit inputs pkgs-stable userSettings systemSettings;
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
        inherit system;
		specialArgs = {
			inherit inputs pkgs-stable userSettings systemSettings;
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
}

	


