{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        ohmyposh.enable = mkEnableOption "Enable oh-my-posh";
    };

    config = mkIf config.ohmyposh.enable {
        home-manager.users.${userSettings.username} = {
            programs.oh-my-posh = {
                enable = true;
                enableNushellIntegration = mkIf config.nushell.enable true;
            };
        };
    };
}
