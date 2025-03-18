{ inputs, userSettings, systemSettings, ... }:

let
    inherit (systemSettings) system;
    inherit (inputs) nixpkgs nixpkgs-stable home-manager;

	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};

	pkgs-stable = import nixpkgs-stable {
		inherit system;
		config.allowUnfree = true;
	};

	lib = nixpkgs.lib;

in

{
	betelgeuse = lib.nixosSystem {
        inherit system;
		specialArgs = {
			inherit inputs userSettings systemSettings;
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
			
			home-manager.nixosModules.home-manager
			{
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
			}
		];
	};
}

	


