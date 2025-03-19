{ config, lib, pkgs, inputs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.hyprpaper;
in
{
    options = {
        hyprpaper.enable = mkEnableOption "Enable hyprpaper";
    };

    config = mkIf cfg.enable {
        
        environment.systemPackages = with pkgs; [
            hyprpaper
        ];

        home-manager.users.${userSettings.username} = {

            services.hyprpaper = {
                enable = true;
                settings = {
                    ipc = true;
                };
            };
        };
    };
}
