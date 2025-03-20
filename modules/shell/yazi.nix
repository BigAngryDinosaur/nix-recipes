{ config, lib, pkgs, inputs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.yazi;
in {

    options = {
        yazi.enable = mkEnableOption "Enable Yazi";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {

            home = {
                packages = with pkgs; [
                    yazi
                ];
            };

            programs.yazi = {
                enable = true;

                settings = {
                    manager = {
                        ratio = [
                            1
                            4
                            3
                        ];
                        sort_by = "natural";
                        sort_sensitive = true;
                        sort_reverse = false;
                        sort_dir_first = true;
                        linemode = "none";
                        show_hidden = true;
                        show_symlink = true;
                    };
                };
            };
        };
    };
}
