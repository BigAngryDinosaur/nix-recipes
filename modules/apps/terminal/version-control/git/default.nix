{ config, lib, userSettings, ...}:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        git.enable = mkEnableOption "Enable git";
    };

    config = mkIf config.git.enable {
        home-manager.users.${userSettings.username} = {
            programs = {
                git = {
                    enable = true;
                };
            };
        };
    };
}
