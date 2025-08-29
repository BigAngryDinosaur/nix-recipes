{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.jjui;
in
{
    options = {
        jjui.enable = mkEnableOption "Enable jjui TUI for jj";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            home.packages = with pkgs; [
                jjui
            ];
        };
    };
}