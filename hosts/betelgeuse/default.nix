
{ config, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	boot = {
		loader = {
			systemd-boot = {
				enable = true;
				configurationLimit = 5;
			};
			efi = {
				canTouchEfiVariables = true;
			};
			timeout = 5;
		};
	};

	hardware = {
		graphics.enable = true;
		nvidia = {
			modesetting.enable = true;
			powerManagement = {
				enable = false;
				finegrained = false;
			};
			open = true;
			nvidiaSettings = true;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
		};
	};

	services.xserver.videoDrivers = ["nvidia"];

	hyprland.enable = true;
}
