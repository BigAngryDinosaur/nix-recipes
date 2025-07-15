
{ config, pkgs, lib, ... }:

{
	imports = [
		./hardware-configuration.nix
        ./keyd.nix
	];

	boot = {
		loader = {
			systemd-boot = {
				enable = true;
				configurationLimit = 15;
			};
			efi = {
				canTouchEfiVariables = true;
			};
			timeout = 10;
		};
		kernelPackages = pkgs.linuxPackages_latest;	
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

    niri.enable = true;
    obs.enable = lib.mkForce false;
    spotify.enable = lib.mkForce false;
}
