{
    description = "NixOS Recipes";

    outputs = inputs @ { self, ... }:
        let
            userSettings = rec {
                username = "rusha";
                name = "Rusha";
                email = "hrishikesh.sawant322@gmail.com";
                wm = "niri";
                theme = "io";
                browser = "firefox";
                editor = "nvim";
                terminal = "ghostty";
            };

            systemSettings = {
                timeZone = "Asia/Tokyo";
                locale = "en_US.UTF-8";
            };
	
        in
            {
            nixosConfigurations = (
                import ./hosts {
                    inherit inputs userSettings systemSettings; 
                }
            );
        };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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

        hyprspace = {
            url = "github:KZDKM/Hyprspace";
            inputs.hyprland.follows = "hyprland";
        };

        niri = {
            url = "github:sodiboo/niri-flake/4d0ba35";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        rose-pine-hyprcursor = {
            url = "github:ndom91/rose-pine-hyprcursor";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.hyprlang.follows = "hyprland/hyprlang";
        };

        ghostty = {
            url = "github:ghostty-org/ghostty";
        };

        stylix = {
            url = "github:danth/stylix";
        };

        swww = {
            url = "github:LGFae/swww";
        };
    };
}
