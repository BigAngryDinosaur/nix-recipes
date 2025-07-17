{ config, pkgs, userSettings, ... }:
{
    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = [ "*" ];
                settings = {
                    alt = {
                        insert = "C-a";
                    };
                    control = {
                        insert = "C-c";
                    };
                    meta = {
                        insert = "C-v";
                    };
                };
                extraConfig = ''
                '';
            };
        };
    };

    home-manager.users.${userSettings.username} = {
        home.file.".config/keyd/app.conf".text = ''
            [ghostty]
            control.insert = C-S-c
            meta.insert = C-S-v
        '';
    };

    environment.systemPackages = with pkgs; [
        keyd
    ];
}
