{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.jj;
in
{
    options = {
        jj.enable = mkEnableOption "Enable jj";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.jujutsu = {
                enable = true;
            };
        };
    };
}
