{ config, ... }: {

    imports = [
        ./gdb.nix    
        ./devenv.nix
        ./direnv.nix
        ./ai-assistants
    ];

    config = {
        devenv.enable = true;
        direnv.enable = true;
    };
}
