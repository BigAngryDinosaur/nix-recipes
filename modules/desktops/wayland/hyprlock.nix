{ pkgs, userSettings, ... }:

{
    home-manager.users.${userSettings.username} = {

        programs.hyprlock = {
            enable = true;
        };
    };
}

