{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.zoxide;
in
    {
    options = {
        zoxide.enable = mkEnableOption "Enable zoxide";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.zoxide = {
                enable = true;
                enableZshIntegration = true;
            };
        };
    };
}
