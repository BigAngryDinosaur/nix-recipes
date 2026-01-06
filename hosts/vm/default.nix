{ config, pkgs, lib, ... }:
{
	imports = [
		./hardware-configuration.nix
        ../../modules/audio
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

    # Enable VM-optimized audio to fix stuttering
    audio.vm.enable = true;

    niri.enable = true;
    spotify.enable = lib.mkForce false;
    stremio.enable = lib.mkForce false;
}
