{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.ripgrep;
in {
    options = {
        ripgrep.enable = mkEnableOption "Enable ripgrep";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.ripgrep = {
                enable = true;
            };
        };
    };
}