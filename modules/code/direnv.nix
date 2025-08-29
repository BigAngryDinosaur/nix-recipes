{ config, pkgs, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.direnv;
in
{
    options = {
        direnv.enable = mkEnableOption "Enable direnv";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.direnv = {
                enable = true;
                enableZshIntegration = true;
                enableNushellIntegration = true;
                silent = true;
            };
        };
    };
}
