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

        environment.systemPackages = with pkgs; [
            eza
            fd
            jq
            bat
            ripgrep
        ];

        programs.zsh = {
            enable = true;
            autosuggestions.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;
            histSize = 100000;

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

            ohMyZsh = {
                enable = true;
                theme = "robbyrussell";
                plugins = [ "git" "eza" ];
            };

        };
    };
}
