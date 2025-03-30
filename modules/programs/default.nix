{ config, pkgs, ... }: {
    
    imports = [
        ./kanata
        ./spotify
        ./neovim
        ./ghostty.nix
        ./obs.nix
        ./ffmpeg.nix
    ];

    config = {

        obs.enable = true;
        ffmpeg.enable = true;
    };
}
