{ config, ... }: {

    imports = [
        ./claude-code.nix
    ];

    config = {
        claude-code.enable = true;
    };
}