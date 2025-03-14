{
  description = "NixOS Recipes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
    	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
    	url = "github:hyprwm/Hyprland";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
    	url = "github:hyprwm/hyprland-plugins";
	inputs.hyprland.follows = "hyprland";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, hyprland, ... } :
    let
      vars = {
      	user = {
			name = "rusha";
			description = "Rusha";
		};
		location = "$HOME/.nixos-recipes";
		terminal = "kitty";
		editor = "nvim";
      };
      in
      {
      	nixosConfigurations = (
	  import ./hosts {
	    inherit inputs nixpkgs nixpkgs-stable nixos-hardware home-manager hyprland vars;
	  }
	);
      };
  }
