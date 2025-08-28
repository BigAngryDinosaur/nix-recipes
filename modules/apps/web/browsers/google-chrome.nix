{ config, lib, pkgs, ... }: {

    options.google-chrome.enable = lib.mkEnableOption "Google Chrome browser";

    config = lib.mkIf config.google-chrome.enable {
        environment.systemPackages = [
            pkgs.google-chrome
        ];
    };
}