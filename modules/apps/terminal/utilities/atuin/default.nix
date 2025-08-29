{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.atuin;
in {
    options = {
        atuin.enable = mkEnableOption "Enable atuin";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.atuin = {
                enable = true;
                enableZshIntegration = mkIf config.zsh.enable true;
                enableNushellIntegration = mkIf config.nushell.enable true;
            };
        };
    };
}