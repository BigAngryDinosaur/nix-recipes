{ config, ... }: {

    imports = [
        ./chromium.nix
        ./google-chrome.nix
    ];

    chromium.enable = true;
    google-chrome.enable = false;
}