{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        zellij.enable = mkEnableOption "Enable Zellij";
    };

    config = mkIf config.zellij.enable {
        home-manager.users.${userSettings.username} = {
            programs.zellij = {
                enable = true;
            };

            home.file.".config/zellij/layouts" = {
                source = ./layouts;
                recursive = true;
            };
        };
    };
}
