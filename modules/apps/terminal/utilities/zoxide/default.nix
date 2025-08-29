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
                enableZshIntegration = mkIf config.zsh.enable true;
                enableNushellIntegration = mkIf config.nushell.enable true;
            };
        };
    };
}
