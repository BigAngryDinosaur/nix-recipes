
{ config, lib, pkgs, inputs, userSettings, systemSettings, ... }:

{
	imports = (
		import ../modules/desktops ++
		import ../modules/styles ++
		import ../modules/shell ++ 
		import ../modules/programs
	);

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
            # Utils
            coreutils
			wget

            # A/V
			alsa-utils
			pavucontrol
			pipewire
			pulseaudio
            vlc
            mpv
            feh

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


	home-manager.users.${userSettings.username} = {

		home = {
			stateVersion = "24.11";
		};

		programs = {
			home-manager.enable = true;
		};
	};
}
