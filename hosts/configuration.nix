
{ config, lib, pkgs, inputs, userSettings, systemSettings, ... }:

{
	imports = [
        ../modules/security
		../modules/desktops
		../modules/styles
		../modules/shell
		../modules/programs
	    ../modules/apps
	    ../modules/network
	    ../modules/audio
        ../modules/code
        ../modules/cloud
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

	# Enable standard PipeWire audio for non-VM hosts
	audio.pipewire.enable = true;
	
	# Enable Google Chrome by default
	google-chrome.enable = lib.mkDefault true;

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
            wev

            # A/V
            vlc
            mpv
            oculante

            # Browsers
			firefox

            # File Management
            p7zip
            zip
            unzip
            unrar

            # Development
            zig

            # AI
            claude-code
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

            sessionVariables = {
                EDITOR = "${userSettings.editor}";
            };

			stateVersion = "25.05";
		};

		programs = {
			home-manager.enable = true;
		};
	};
}
