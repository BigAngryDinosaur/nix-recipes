{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.firefox;
in
{
    options = {
        firefox.enable = mkEnableOption "Firefox browser";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.firefox = {
                enable = true;
                package = pkgs.firefox;
            };
        };
    };
}