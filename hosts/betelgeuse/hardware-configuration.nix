
{ config, lib, pkgs, modulesPath, host, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/disk/by-uuid/93ca6e2d-8cf2-4934-975f-0ed38de97184";
            fsType = "btrfs";
            options = [ "subvol=@" ];
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/6313-85EC";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

    swapDevices =
        [ { device = "/dev/disk/by-uuid/2fa46205-28e5-4ba1-808f-b9724bed91f9"; }
        ];

    networking = {
        useDHCP = lib.mkDefault true;
        hostName = host.name;
        networkmanager = {
            enable = true;
        };
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
