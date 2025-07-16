{ config, userSettings, ... }:
{
    services.keyd.enable = false;

    home-manager.users.${userSettings.username} = {
        home.file.".config/keyd/default.conf".text = ''
            [ids]
            *

            [main]
            leftalt-insert = C-a
            leftcontrol-insert = C-S-c
            leftshift-insert = C-t
            leftalt-meta-insert = C-q
        '';
    };
}
