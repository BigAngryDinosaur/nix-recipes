{ config, userSettings, ... }:
{
    services.keyd.enable = true;

    home-manager.users.${userSettings.username} = {
        home.file.".config/keyd/default.conf".text = ''
            [ids]
            *
        '';
    };
}
