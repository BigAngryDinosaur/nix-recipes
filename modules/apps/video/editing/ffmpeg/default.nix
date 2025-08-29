{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.ffmpeg;
in
{
    options = {
        ffmpeg.enable = mkEnableOption "Enable ffmpeg";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [
            pkgs.ffmpeg
        ];
    };
}

