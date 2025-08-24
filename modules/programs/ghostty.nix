{ config, userSettings, pkgs, lib, ... }:

{
    home-manager.users.${userSettings.username} = {
        programs.ghostty = {
            enable = true;
            enableZshIntegration = config.zsh.enable;
            settings = {
                window-decoration = false;
                window-padding-x = 6;
                window-padding-y = 6;
                background-blur = true;
                keybind = [
                    "shift+enter=text:\\n"
                ];
            } // lib.optionalAttrs config.nushell.enable {
                command = "${pkgs.nushell}/bin/nu";
            };
        };
    };
}
