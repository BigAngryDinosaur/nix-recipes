
{ config, lib, pkgs, stable, hyprland, inputs, vars, ... }:

{

	users.users.${vars.user.name} = {
		isNormalUser = true;
		description = "${vars.user.description}";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	time = {
		timeZone = "Asia/Tokyo";
	};

	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "en_US.UTF-8";
			LC_IDENTIFICATION = "en_US.UTF-8";
			LC_MEASUREMENT = "en_US.UTF-8";
			LC_MONETARY = "en_US.UTF-8";
			LC_NAME = "en_US.UTF-8";
			LC_NUMERIC = "en_US.UTF-8";
			LC_PAPER = "en_US.UTF-8";
			LC_TELEPHONE = "en_US.UTF-8";
			LC_TIME = "en_US.UTF-8";
		};
	};

	hardware = {
		pulseaudio.enable = false;
	};

	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = ["nix-command" "flakes"];
		};
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 14d";
		};
		registry.nixpkgs.flake = inputs.nixpkgs;
	};

	nixpkgs.config.allowUnfree = true;

	system = {
		stateVersion = "24.11";
	};

	environment = {
		systemPackages = with pkgs; [
			git
			wget
			firefox
			neovim
		];
	};

	programs.hyprland = {
		enable = true;
		package = hyprland.packages.${pkgs.system}.hyprland;
	};

	home-manager.users.${vars.user.name} = {
		home = {
			stateVersion = "24.11";
		};
		programs = {
			home-manager.enable = true;
		};
	};
}
