{ config, ... }: {
    
    imports = [
        ./kanata
        ./spotify
        ./neovim
        ./ghostty.nix
        ./obs.nix
    ];

    config = {
        obs.enable = true;
    };
}
