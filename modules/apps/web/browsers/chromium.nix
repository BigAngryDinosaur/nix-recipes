{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.chromium;
in
{
    options = {
        chromium.enable = mkEnableOption "Chromium browser";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.chromium = {
                enable = true;
                package = pkgs.chromium;
            };
        };
    };
}