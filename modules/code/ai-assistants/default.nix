{ config, ... }: {

    imports = [
        ./claude-code.nix
        ./gemini-cli.nix
    ];

    config = {
        claude-code.enable = true;
        gemini-cli.enable = true;
    };
}