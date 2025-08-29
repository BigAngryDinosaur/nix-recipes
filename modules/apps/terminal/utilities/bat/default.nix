{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.bat;
in {
    options = {
        bat.enable = mkEnableOption "Enable bat";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.bat = {
                enable = true;
            };
        };
    };
}