{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.nushell;
in
{
    options = {
        nushell.enable = mkEnableOption "Enable NuShell";
    };

    config = mkIf cfg.enable {
        
        home-manager.users.${userSettings.username} = {

            programs = {
                nushell = {
                    enable = true;
                };

                carapace.enable = true;
                carapace.enableNushellIntegration = true;
            };
        };
    };
}
