{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.devenv;
in
{
    options = {
        devenv.enable = mkEnableOption "Enable devenv";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            home.packages = [
                pkgs.devenv
            ];
        };
    };
}
