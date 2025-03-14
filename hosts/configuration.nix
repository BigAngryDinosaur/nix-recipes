
{ config, lib, pkgs, stable, hyprland, inputs, vars, ... }:

{
	imports = (
		import ../modules/desktops ++
		import ../modules/styles
	);

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

	
	security.rtkit.enable = true;
	services = {
		pulseaudio.enable = false;
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
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

	fonts.packages = with pkgs; [
		carlito
		vegur
		source-code-pro
		jetbrains-mono
		font-awesome
		corefonts
		nerd-fonts.fira-code
	];

	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	environment = {
		systemPackages = with pkgs; [
			git
			wget
			neovim
			kitty
			ripgrep

			alsa-utils
			pavucontrol
			pipewire
			pulseaudio

			firefox
			google-chrome

			pcmanfm
		];

	};

	programs = {
		dconf.enable = true;
		_1password.enable = true;
		_1password-gui = {
			enable = true;
			polkitPolicyOwners = [ "${vars.user.name}" ];
		};
	};


	home-manager.users.${vars.user.name} = {

		home = {
			stateVersion = "24.11";
		};

		programs = {
			home-manager.enable = true;
			kitty.enable = true;
		};
	};
}
