{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.obs;
in
{
    options = {
        obs.enable = mkEnableOption "Enable OBS";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.obs-studio = {
                enable = true;
                plugins = with pkgs.obs-studio-plugins; [
                    wlrobs
                    obs-backgroundremoval
                    obs-pipewire-audio-capture
                ];
            };
        };
    };
}

