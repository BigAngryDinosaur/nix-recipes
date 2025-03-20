{ config, ... }:

{
    imports = [
        ./git.nix
        ./starship.nix
        ./zsh.nix
        ./yazi.nix
    ];

    config = {
        zsh.enable = true;
        yazi.enable = true;
        starship.enable = true;
    };
}

