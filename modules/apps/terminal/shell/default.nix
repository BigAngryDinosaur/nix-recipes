{ config, ... }: {
    imports = [
        ./zsh
        ./nu
    ];

    config = {
        zsh.enable = true;
        nushell.enable = true;
    };
}
