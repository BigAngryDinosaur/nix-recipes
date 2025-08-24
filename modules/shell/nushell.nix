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
        television.enable = true;

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

                    extraConfig = ''
                        # Open files
                        def open-file [--show-hidden, --ignore-vcs, --use-vcs-ignore] {
                            mut fd_args = ["-t" "f" ]
                            let vcs = ["git" "jj"] 

                            if $show_hidden {
                                $fd_args = ($fd_args | append "-H")
                            }

                            if $ignore_vcs {
                                let ignored_vcs = $vcs | each { |el| ["-E" $".($el)"] }
                                $fd_args = ($fd_args | append $ignored_vcs) | flatten
                            }

                            if $use_vcs_ignore and (".gitignore" | path exists) {
                                $fd_args = ($fd_args | append ["--ignore-file" ".gitignore"])
                            }

                            let file = (fd ...$fd_args | tv --preview 'bat -n --color=always {0}')
                            if ($file | is-not-empty) {
                                nvim $"($file)"
                            }
                        }

                        alias fe = open-file --use-vcs-ignore
                        alias feh = open-file --show-hidden --use-vcs-ignore --ignore-vcs
                        alias fea = open-file --show-hidden
                    '';
                };

                carapace.enable = true;
                carapace.enableNushellIntegration = true;

            };
        };
    };
}
