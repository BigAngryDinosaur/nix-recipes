{ config, ... }: {

    imports = [
        ./chromium.nix
        ./firefox.nix
        ./google-chrome.nix
    ];

    chromium.enable = true;
    firefox.enable = true;
    google-chrome.enable = false;
}