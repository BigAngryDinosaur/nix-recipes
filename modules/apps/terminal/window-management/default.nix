{ config, ... }: {
    imports = [
        ./tmux
        ./zellij
    ];

    config = {
        tmux.enable = true;
        zellij.enable = true;
    };
}
