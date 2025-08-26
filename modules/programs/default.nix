{ config, pkgs, lib, ... }: {

    imports = [
        ./spotify
        ./neovim
        ./ghostty.nix
        ./obs.nix
        ./ffmpeg.nix
    ];

    config = {
        obs.enable = true;
        spotify.enable = true;
        ffmpeg.enable = true;
    };
}
