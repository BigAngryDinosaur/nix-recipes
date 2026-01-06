{ config, ... }: {
    imports = [
        ./editing/obs
        ./editing/ffmpeg
    ];

    config = {
        obs.enable = true;
        ffmpeg.enable = true;
        stremio.enable = true;
    };
}
