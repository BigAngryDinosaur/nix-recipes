{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.zsh;
in {

    options = {
        zsh.enable = mkEnableOption "Enable zsh";
    };

    config = mkIf cfg.enable {

        users.users.${userSettings.username} = {
            shell = pkgs.zsh;
        };

        eza.enable = true;
        starship.enable = true;
        zoxide.enable = true;
        fzf.enable = true;
        fd.enable = true;
        jq.enable = true;
        bat.enable = true;
        ripgrep.enable = true;

        programs.zsh.enable = true;

        home-manager.users.${userSettings.username} = {
            programs.zsh = {
                enable = true;
                package = pkgs.zsh;
                autosuggestion.enable = true;
                syntaxHighlighting.enable = true;
                enableCompletion = true;
                history.size = 100000;

                shellAliases = {

                    # Eza
                    l = "eza -lah --icons=auto";
                    lg = "eza -lH --git";
                    lt = "eza -T";

                    # Editor
                    e = "${userSettings.editor}";

                    # General
                    c = "clear";
                };

                oh-my-zsh = {
                    enable = true;
                    theme = "robbyrussell";
                    plugins = [ "git" "eza" "fzf" ];
                };

                initContent = ''
                    source ${./functions.zsh}
                '';
            };
        };
    };
}
