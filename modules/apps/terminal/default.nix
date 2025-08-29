{ config, ... }: {
    imports = [
        ./emulators/ghostty
        ./shell
        ./window-management
        ./prompt
        ./file-managers
        ./version-control
        ./utilities
    ];
}
