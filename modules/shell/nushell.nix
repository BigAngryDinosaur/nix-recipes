{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.nushell;
in
{
    options = {
        nushell.enable = mkEnableOption "Enable NuShell";
    };

    config = mkIf cfg.enable {
        
        eza.enable = true;
        ohmyposh.enable = true;

        home-manager.users.${userSettings.username} = {
            programs = {
                nushell = {
                    enable = true;

                    settings = {
                        show_banner = false;
                        buffer_editor = "nvim";
                        edit_mode = "vi";
                    };

                    shellAliases = {
                        e = "nvim";
                        c = "clear";

                        # eza
                        l = "eza -la --icons";
                        lt = "eza -T --icons";
                    };
                };

                carapace.enable = true;
                carapace.enableNushellIntegration = true;
            };
        };
    };
}
