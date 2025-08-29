{ config, ... }: {
    imports = [
        ./editing/obs
        ./editing/ffmpeg
        ./streaming/stremio
    ];

    config = {
        obs.enable = true;
        ffmpeg.enable = true;
    };
}