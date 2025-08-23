{ config, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.starship;
in
    {
    options = {
        starship.enable = mkEnableOption "Enable Starship";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {

            programs.starship = {
                enable = true;
                settings = {
                    character = {
                        success_symbol = "[›](bold green)";
                        error_symbol = "[›](bold red)";
                    };

                    git_status = {
                        deleted = "✗";
                        modified = "✶";
                        staged = "✓";
                        stashed = "≡";
                    };

                    format = "$all$direnv";
                };
                enableNushellIntegration = true;
            };

        };
    };
}
