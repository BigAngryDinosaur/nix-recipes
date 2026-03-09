{ config, ... }: {

    imports = [
        ./claude-code.nix
        ./gemini-cli.nix
        ./codex-cli.nix
        ./antigravity.nix
        ./pi.nix
    ];

    config = {
        claude-code.enable = true;
        gemini-cli.enable = true;
        codex-cli.enable = true;
        antigravity.enable = true;
        pi.enable = true;
    };
}
