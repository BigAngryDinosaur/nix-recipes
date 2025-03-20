
{ config, lib, pkgs, inputs, userSettings, systemSettings, ... }:

{
	imports = [
		../modules/desktops
		../modules/styles
		../modules/shell
		../modules/programs
    ];

	users.users.${userSettings.username} = {
		isNormalUser = true;
		description = "${userSettings.name}";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	time = {
		timeZone = "${systemSettings.timeZone}";
	};

	i18n = {
		defaultLocale = "${systemSettings.locale}";
		extraLocaleSettings = {
			LC_ADDRESS = "${systemSettings.locale}";
			LC_IDENTIFICATION = "${systemSettings.locale}";
			LC_MEASUREMENT = "${systemSettings.locale}";
			LC_MONETARY = "${systemSettings.locale}";
			LC_NAME = "${systemSettings.locale}";
			LC_NUMERIC = "${systemSettings.locale}";
			LC_PAPER = "${systemSettings.locale}";
			LC_TELEPHONE = "${systemSettings.locale}";
			LC_TIME = "${systemSettings.locale}";
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

	system = {
		stateVersion = "25.05";
	};

    console = {
		keyMap = "us";
	};

	environment = {
		systemPackages = with pkgs; [
            # Utils
            coreutils
			wget
            fastfetch

            # A/V
			alsa-utils
			pavucontrol
			pipewire
			pulseaudio
            vlc
            mpv
            oculante

            # Browsers
			firefox
			google-chrome

            # File Management
			pcmanfm
            p7zip
            zip
            unzip
            unrar
		];

	};

	programs = {
		dconf.enable = true;
		_1password.enable = true;
		_1password-gui = {
			enable = true;
			polkitPolicyOwners = [ "${userSettings.username}" ];
		};
	};

    nixpkgs.config.allowUnfree = true;

	home-manager.users.${userSettings.username} = {

		home = {
			stateVersion = "25.05";
		};

		programs = {
			home-manager.enable = true;
		};
	};
}
