{ config, ... }: {
    imports = [
        ./yazi
    ];

    config = {
        yazi.enable = true;
    };
}
