{ config, ... }: {
    imports = [
        ./emulators/ghostty
        ./shell/nu
        ./shell/zsh
        ./window-management/tmux
        ./window-management/zellij
        ./prompt/starship
        ./prompt/ohmyposh
        ./file-managers/yazi
        ./version-control/git
        ./version-control/jj
        ./utilities/eza
        ./utilities/zoxide
        ./utilities/television
        ./utilities/fzf
    ];

    config = {
        zsh.enable = true;
        nushell.enable = true;
        yazi.enable = true;
        starship.enable = true;
        fzf.enable = true;
        zoxide.enable = true;
        tmux.enable = true;
        jj.enable = true;
    };
}