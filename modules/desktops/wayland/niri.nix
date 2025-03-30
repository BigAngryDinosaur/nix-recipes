
{ config, lib, pkgs, inputs, userSettings, host, ... }:

let
    inherit (lib) mkEnableOption mkIf mkDefault;
    inherit (host) monitors;

    cfg = config.niri;
in
    {
    options = {
        niri.enable = mkEnableOption "Enable Niri";
    };

    config = mkIf cfg.enable {

        wofi.enable = true;
        waybar.enable = true;
        swww.enable = true;

        programs.niri = {
            enable = true;
            package = pkgs.niri;
        };

        nixpkgs.overlays = [
            inputs.niri.overlays.niri
        ];

        home-manager.users.${userSettings.username} = let
            makeCommand = command: {
                command = [command];
            } ;
            in
            {

            programs.niri = {

                settings = {

                    spawn-at-startup = [
                        (makeCommand "hyprlock")
                        (makeCommand "waybar")
                        (makeCommand "swww-daemon")
                        (makeCommand "swww-daemon img $HOME/Videos/osaka-rain.gif")
                    ];

                    input = {
                        keyboard.xkb.layout = "us";
                        focus-follows-mouse.enable = true;
                        warp-mouse-to-focus = true;
                        workspace-auto-back-and-forth = true;
                    };

                    outputs = (
                        if host.name == "betelgeuse" then
                        {
                            "${toString monitors.left}" = {
                                scale = 1.0;
                                transform.rotation = 90; 
                                mode = {
                                    width = 1920;
                                    height = 1200;
                                    refresh = 100.0;
                                };
                                position = {
                                    x = 0;
                                    y = 0;
                                };
                            };
                            "${toString monitors.middle}" = {
                                scale = 1.25;
                                transform.rotation = 0; 
                                mode = {
                                    width = 3840;
                                    height = 2160;
                                    refresh = 119.88;
                                };
                                position = {
                                    x = 1200;
                                    y = 0;
                                };
                            };
                            "${toString monitors.right}" = {
                                scale = 1.0;
                                transform.rotation = 270; 
                                mode = {
                                    width = 1920;
                                    height = 1200;
                                    refresh = 100.0;
                                };
                                position = {
                                    x = 4272;
                                    y = 0;
                                };
                            }; 
                            "${toString monitors.tv}" = {
                                scale = 1.50;
                                transform.rotation = 0; 
                                mode = {
                                    width = 3840;
                                    height = 2160;
                                    refresh = 60.00;
                                };
                                position = {
                                    x = 0;
                                    y = 2160;
                                };
                            };
                        }
                        else if host.name == "vm" then
                        {
                            "${toString monitors.main}" = {
                                scale = 1.50;
                                mode = {
                                    width = 2560;
                                    height = 1600;
                                    refresh = 59.987;
                                };
                            };
                        }
                        else 
                            abort "Invalid host"
                    );

                    binds = let
                        hyper = "Ctrl+Alt+Shift+Super";
                        meh = "Ctrl+Alt+Shift";
                    in {
                        "${meh}+Return".action.spawn = "${pkgs.ghostty}/bin/ghostty";
                        "${meh}+Space".action.spawn = "wofi";
                        "${meh}+F".action.spawn = "${pkgs.firefox}/bin/firefox";
                        "${meh}+D".action.spawn = ["sh" "-c" "${pkgs.ghostty}/bin/ghostty -e yazi"];

                        "Ctrl+Alt+L".action.spawn = "hyprlock";

                        "Mod+Q".action.close-window = [];
                        "Mod+O".action.switch-preset-column-width = [];
                        "Mod+Alt+O".action.switch-preset-window-height = [];
                        "Mod+Alt+P".action.reset-window-height = [];
                        "Mod+F".action.maximize-column = [];
                        "Mod+Alt+F".action.fullscreen-window = [];
                        "Mod+Shift+Space".action.toggle-window-floating = [];

                        "Mod+Alt+U".action.consume-window-into-column = [];
                        "Mod+Alt+I".action.expel-window-from-column = [];
                        "Mod+U".action.consume-or-expel-window-left = [];
                        "Mod+I".action.consume-or-expel-window-right = [];
                        "Mod+D".action.center-window = [];
                        "Mod+G".action.switch-focus-between-floating-and-tiling = [];

                        "Mod+Shift+H".action.set-column-width = "-10%";
                        "Mod+Shift+L".action.set-column-width = "+10%";
                        "Mod+Shift+J".action.set-window-height = "-10%";
                        "Mod+Shift+K".action.set-window-height = "+10%";

                        "Mod+H".action.focus-column-left = [];
                        "Mod+L".action.focus-column-right = [];
                        "Mod+J".action.focus-window-or-workspace-down = [];
                        "Mod+K".action.focus-window-or-workspace-up = [];

                        "Mod+Alt+H".action.move-column-left = [];
                        "Mod+Alt+L".action.move-column-right = [];
                        "Mod+Alt+K".action.move-column-to-workspace-up = [];
                        "Mod+Alt+J".action.move-column-to-workspace-down = [];

                        "Mod+1".action.focus-workspace = 1;
                        "Mod+2".action.focus-workspace = 2;
                        "Mod+3".action.focus-workspace = 3;
                        "Mod+4".action.focus-workspace = 4;
                        "Mod+5".action.focus-workspace = 5;
                        "Mod+6".action.focus-workspace = 6;
                        "Mod+7".action.focus-workspace = 7;
                        "Mod+8".action.focus-workspace = 8;
                        "Mod+9".action.focus-workspace = 9;
                        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
                        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
                        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
                        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
                        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
                        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
                        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
                        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
                        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

                        "Mod+Alt+Ctrl+H".action.move-column-to-monitor-left = [];
                        "Mod+Alt+Ctrl+L".action.move-column-to-monitor-right = [];

                        "Mod+Ctrl+H".action.focus-monitor-left = [];
                        "Mod+Ctrl+L".action.focus-monitor-right = [];

                        "Mod+W".action.toggle-column-tabbed-display = [];
                    };

                    window-rules = [
                        {
                            draw-border-with-background = false;
                        }
                    ];

                    prefer-no-csd = true;
                };
            };

        };
    };
}
