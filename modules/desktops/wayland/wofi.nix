{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.wofi;
in {

    options = {
        wofi.enable = mkEnableOption "Enable Wofi";
    };

    config = mkIf cfg.enable {

        home-manager.users.${userSettings.username} = {

            programs.wofi = {
                enable = true;

                settings = {
                    show = "drun";
                    width = 512;
                    height = 384;
                    always_parse_args = true;
                    show_all = true;
                    print_command = true;
                    prompt = "";
                    layer = "overlay";
                    insensitive = true;
                    content_halign = "top";
                    allow_images = true;

                };
            };
        };
    };
}

