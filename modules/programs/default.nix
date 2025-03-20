{ config, ... }: {
    
    imports = [
        ./kanata
        ./spotify
        ./neovim
        ./ghostty.nix
    ];
}
