{ config, ... }:

{
    imports = [
        ./git.nix
        ./starship.nix
        ./yazi.nix
        ./fzf.nix
        ./zoxide.nix
        ./zsh.nix
        ./nushell.nix
        ./tmux.nix
    ];

    config = {
        zsh.enable = true;
        nushell.enable = true;
        yazi.enable = true;
        starship.enable = true;
        fzf.enable = true;
        zoxide.enable = true;
        tmux.enable = true;
    };
}

