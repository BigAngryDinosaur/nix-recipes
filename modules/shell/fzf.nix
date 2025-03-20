{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.fzf;
in {
    options = {
        fzf.enable = mkEnableOption "Enable fzf";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.fzf = {
                enable = true;
            };
        };
    };
}
