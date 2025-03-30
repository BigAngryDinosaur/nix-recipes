
{ config, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/nvme0n1";
	boot.loader.grub.useOSProber = true;

    virtualisation.vmware.guest.enable = true;

    #hyprland.enable = true;
    niri.enable = true;
}
