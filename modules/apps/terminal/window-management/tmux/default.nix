{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.tmux;
in
{
    options = {
        tmux.enable = mkEnableOption "Enable tmux";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.tmux = {
                enable = true;
            };
        };
    };
}
