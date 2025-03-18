
{ config, lib, pkgs, inputs, userSettings, host, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    inherit (host) monitors;

    cfg = config.niri;
in
    {
    options = {
        niri.enable = mkEnableOption "Enable Niri";
    };

    config = mkIf cfg.enable {
        wlwm.enable = true;

        services.greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.niri}/bin/niri-session";
                    user = userSettings.username;
                };
                vt = 7;
            };
        };

        programs.niri = {
            enable = true;
            package = pkgs.niri;
        };

        nixpkgs.overlays = [
            inputs.niri.overlays.niri
        ];

        home-manager.users.${userSettings.username} = {

            programs.niri = {

                settings = {
                    outputs = {
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
                    };

                    binds = {
                        "Mod+Return".action.spawn = "${pkgs.ghostty}/bin/ghostty";
                        "Mod+P".action.spawn = "${pkgs.firefox}/bin/firefox";
                        "Mod+Space".action.spawn = "wofi --show drun";
                        "Ctrl+Alt+L".action.spawn = "sh -c pgrep hyprlock || hyprlock";

                        "Mod+Q".action.close-window = [];
                        "Mod+R".action.switch-preset-column-width = [];
                        "Mod+Shift+R".action.switch-preset-window-height = [];
                        "Mod+Ctrl+R".action.reset-window-height = [];
                        "Mod+F".action.maximize-column = [];
                        "Mod+Shift+F".action.fullscreen-window = [];
                        "Mod+Shift+Space".action.toggle-window-floating = [];

                        "Mod+Shift+BracketLeft".action.consume-window-into-column = [];
                        "Mod+Shift+BracketRight".action.expel-window-from-column = [];
                        "Mod+BracketLeft".action.consume-or-expel-window-left = [];
                        "Mod+BracketRight".action.consume-or-expel-window-right = [];
                        "Mod+C".action.center-window = [];
                        "Mod+Tab".action.switch-focus-between-floating-and-tiling = [];

                        "Mod+Minus".action.set-column-width = "-10%";
                        "Mod+Equal".action.set-column-width = "+10%";
                        "Mod+Shift+Minus".action.set-window-height = "-10%";
                        "Mod+Shift+Equal".action.set-window-height = "+10%";

                        "Mod+H".action.focus-column-left = [];
                        "Mod+L".action.focus-column-right = [];
                        "Mod+J".action.focus-window-or-workspace-down = [];
                        "Mod+K".action.focus-window-or-workspace-up = [];
                        "Mod+Left".action.focus-column-left = [];
                        "Mod+Right".action.focus-column-right = [];
                        "Mod+Down".action.focus-workspace-down = [];
                        "Mod+Up".action.focus-workspace-up = [];
                        "Mod+Home".action.focus-column-first = [];
                        "Mod+End".action.focus-column-last = [];
                        "Mod+Shift+Home".action.move-column-to-first = [];
                        "Mod+Shift+End".action.move-column-to-last = [];

                        "Mod+Shift+H".action.move-column-left = [];
                        "Mod+Shift+L".action.move-column-right = [];
                        "Mod+Shift+K".action.move-column-to-workspace-up = [];
                        "Mod+Shift+J".action.move-column-to-workspace-down = [];
                        "Mod+Shift+Left".action.move-column-left = [];
                        "Mod+Shift+Right".action.move-column-right = [];
                        "Mod+Shift+Up".action.move-column-to-workspace-up = [];
                        "Mod+Shift+Down".action.move-column-to-workspace-down = [];

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

                        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [];
                        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [];

                        "Mod+Ctrl+H".action.focus-monitor-left = [];
                        "Mod+Ctrl+L".action.focus-monitor-right = [];
                    };

                };

            };

        };
    };
}
