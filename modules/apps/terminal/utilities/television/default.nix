{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        television.enable = mkEnableOption "Enable television";
    };

    config = mkIf config.television.enable {
        home-manager.users.${userSettings.username} = {
            programs.television = {
                enable = true;
            };
        };
    };
}
