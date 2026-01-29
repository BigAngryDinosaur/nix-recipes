
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
	};

    # Try minimal ALSA setup
    audio.minimal-alsa.enable = true;

    niri.enable = true;
    obs.enable = lib.mkForce false;
    spotify.enable = lib.mkForce false;
    warp.enable = lib.mkForce true;
}
