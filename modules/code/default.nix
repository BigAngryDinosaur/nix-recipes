{ config, ... }: {

    imports = [
        ./gdb.nix    
        ./devenv.nix
    ];

    config = {
        devenv.enable = true;
    };
}
