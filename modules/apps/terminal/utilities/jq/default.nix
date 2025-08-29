{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.jq;
in {
    options = {
        jq.enable = mkEnableOption "Enable jq";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.jq = {
                enable = true;
            };
        };
    };
}