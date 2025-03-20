{ config, ... }:

{
    imports = [
        ./git.nix
        ./starship.nix
        ./zsh.nix
        ./yazi.nix
        ./fzf.nix
        ./zoxide.nix
    ];

    config = {
        zsh.enable = true;
        yazi.enable = true;
        starship.enable = true;
        fzf.enable = true;
        zoxide.enable = true;
    };
}

