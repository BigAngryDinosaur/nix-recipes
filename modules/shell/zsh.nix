
{ pkgs, userSettings, ... }:

{
    users.users.${userSettings.username} = {
        shell = pkgs.zsh;
    };

    home-manager.users.${userSettings.username} = {
        home = {
            packages = with pkgs; [
                eza
                fd
                jq
                bat
            ];
        };
    };

    programs = {
        zsh = {
            enable = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;
            histSize = 100000;

            shellAliases = {

                # Eza
                l = "eza -laH --icons";
                lg = "eza -lH --git";
                lt = "eza -T";

                # Editor
                e = "${userSettings.editor}";
                
                # General
                c = "clear";
            };

            ohMyZsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [ "git" "eza" ];
            };

            shellInit = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
            '';
        };
    };
}
