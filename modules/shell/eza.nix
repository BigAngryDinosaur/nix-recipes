{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        eza.enable = mkEnableOption "Enable eza";
    };

    config = mkIf config.eza.enable {
        home-manager.users.${userSettings.username} = {
            programs.eza = {
                enable = true;
                enableZshIntegration = mkIf config.zsh.enable true;
                enableNushellIntegration = mkIf config.nushell.enable true;
            };
        };
    };
}
