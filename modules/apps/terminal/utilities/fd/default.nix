{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.fd;
in {
    options = {
        fd.enable = mkEnableOption "Enable fd";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.fd = {
                enable = true;
            };
        };
    };
}