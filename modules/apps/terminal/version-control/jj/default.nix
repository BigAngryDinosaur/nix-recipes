{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.jj;
in
{
    imports = [
        ./jjui.nix
    ];

    options = {
        jj.enable = mkEnableOption "Enable jj";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.jujutsu = {
                enable = true;

                settings = {
                    user = {
                        name = lib.strings.toLower userSettings.name;
                        email = userSettings.email;
                    };
                };
            };
        };

        jjui.enable = true;
    };
}
