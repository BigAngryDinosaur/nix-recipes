{ config, ... }: {

    imports = [
        ./gdb.nix    
        ./devenv.nix
        ./direnv.nix
    ];

    config = {
        devenv.enable = true;
        direnv.enable = true;
    };
}
