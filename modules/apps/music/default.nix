{ config, ... }: {
    imports = [
        ./players/spotify
    ];

    config = {
        spotify.enable = true;
    };
}