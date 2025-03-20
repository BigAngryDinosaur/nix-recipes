{ config, userSettings, ... }:

{
    home-manager.users.${userSettings.username} = {
        programs.ghostty = {
            enable = true;
            enableZshIntegration = config.zsh.enable;
            settings = {
                window-decoration = false;
                window-padding-x = 24;
                window-padding-y = 24;
                background-blur = true;
            };
        };
    };
}
