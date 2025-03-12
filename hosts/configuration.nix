
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

	security.rtkit.enable = true;
	services = {
		pulseaudio.enable = false;
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
		greetd = {
			enable = true;
			settings = {
				default_session = {
					command = "${config.programs.hyprland.package}/bin/Hyprland";
					user = vars.user.name;
				}
				vt = 7;
			};
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
		stateVersion = "25.05";
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
			firefox
			neovim
			kitty
		];

		loginShellInit = ''
			if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
				exec dbus-launch Hyprland
			fi
		'';
	};


	home-manager.users.${vars.user.name} = {

		home = {
			stateVersion = "25.05";
		};

		programs = {
			home-manager.enable = true;
			kitty.enable = true;
		};
		
		wayland.windowManager.hyprland = {
			enable = true;
			package = hyprland.packages.${pkgs.system}.hyprland;
			portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

			settings = {
				"$mod" = "SUPER";
				bind = [
					"SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}"
					"SUPER,Q,killactive,"
					"SUPER,Escape,exit,"
					"SUPER,F,togglefloating,"
					"SUPER,h,movefocus,l"
					"SUPER,l,movefocus,r"
					"SUPER,k,movefocus,u"
					"SUPER,j,movefocus,d"
					"SUPERSHIFT,h,movewindow,l"
					"SUPERSHIFT,l,movewindow,r"
					"SUPERSHIFT,k,movewindow,u"
					"SUPERSHIFT,j,movewindow,d"
				];
			};
		};
	};
}
