
{ config, pkgs, lib, ... }:

{
	imports = [
		./hardware-configuration.nix
        ./keyd.nix
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

    # Enable VM-optimized audio to fix stuttering
    audio.vm.enable = true;

    niri.enable = true;
    obs.enable = lib.mkForce false;
    spotify.enable = lib.mkForce false;
    warp.enable = lib.mkForce true;
    
    # Disable Google Chrome on ARM VM
    google-chrome.enable = lib.mkForce false;
}
