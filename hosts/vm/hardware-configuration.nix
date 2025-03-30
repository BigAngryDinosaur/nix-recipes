
{ config, lib, pkgs, modulesPath, host, ... }:

{
    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "ahci" "nvme" "sr_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
    { device = "/dev/disk/by-uuid/9bbc6081-1ca6-4365-965d-e37209d6be32";
	    fsType = "ext4";
    };

    networking = {
        useDHCP = lib.mkDefault true;
        hostName = host.name;
        networkmanager = {
            enable = true;
        };
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
