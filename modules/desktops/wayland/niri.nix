
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

        # Disable the default niri polkit service due to polkit-kde-agent compatibility issues
        systemd.user.services.niri-flake-polkit.enable = false;
        
        # Enable polkit and setup polkit-gnome authentication agent
        security.polkit.enable = true;
        systemd.user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
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
                        (makeCommand "swww-daemon img $HOME/Pictures/green_leaves.jpg")
                    ];

                    input = {
                        keyboard.xkb.layout = "us";
                        focus-follows-mouse.enable = true;
                        warp-mouse-to-focus.enable = true;
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
                                scale = 1.25;
                                mode = {
                                    width = 3840;
                                    height = 2160;
                                    refresh = 60.000;
                                };
                            };
                        }
                        else if host.name == "vm-arm" then
                        {
                            "${toString monitors.main}" = {
                                scale = 1.75;
                                mode = {
                                    width = 3840;
                                    height = 2160;
                                    refresh = 60.000;
                                };
                            };
                        }
                        else if host.name == "mb-arm" then
                        {
                            "${toString monitors.main}" = {
                                scale = 1.50;
                                mode = {
                                    width = 3840;
                                    height = 2160;
                                    refresh = 60.000;
                                };
                            };
                        }
                        else 
                            abort "Invalid host"
                    );

                    binds = let
                        hyper = "Ctrl+Alt+Shift+Super";
                        meh = "Ctrl+Alt+Shift";
                        cam = "Ctrl+Alt+Super";
                        cms = "Ctrl+Super+Shift";
                        ams = "Alt+Super+Shift";
                    in {
                        "${cam}+J".action.spawn = "${pkgs.ghostty}/bin/ghostty";
                        "${cms}+J".action.spawn = ["sh" "-c" "${pkgs.ghostty}/bin/ghostty -e yazi"];

                        "${cam}+F".action.spawn = "wofi";
                        "${cam}+K".action.spawn = ["nu" "-c" "source ~/.config/nushell/scripts/toggle-notes.nu; main"];

                        "Ctrl+Alt+L".action.spawn = "hyprlock";

                        "Ctrl+Q".action.close-window = [];

                        # Focus window
                        "${hyper}+H".action.focus-column-left = [];
                        "${hyper}+L".action.focus-column-right = [];
                        "${hyper}+J".action.focus-window-or-workspace-down = [];
                        "${hyper}+K".action.focus-window-or-workspace-up = [];

                        # Move window
                        "${meh}+A".action.move-column-left = [];
                        "${meh}+F".action.move-column-right = [];
                        "${meh}+S".action.move-window-up = [];
                        "${meh}+D".action.move-window-down = [];

                        # Focus workspace
                        "${meh}+J".action.focus-workspace-down = [];
                        "${meh}+K".action.focus-workspace-up = [];

                        "${hyper}+1".action.focus-workspace = 1;
                        "${hyper}+2".action.focus-workspace = 2;
                        "${hyper}+3".action.focus-workspace = 3;
                        "${hyper}+4".action.focus-workspace = 4;
                        "${hyper}+5".action.focus-workspace = 5;
                        "${hyper}+6".action.focus-workspace = 6;

                        # Move window to workspace
                        "${meh}+M".action.move-column-to-workspace-down = [];
                        "${meh}+comma".action.move-column-to-workspace-up = [];

                        "${meh}+1".action.move-column-to-workspace = 1;
                        "${meh}+2".action.move-column-to-workspace = 2;
                        "${meh}+3".action.move-column-to-workspace = 3;
                        "${meh}+4".action.move-column-to-workspace = 4;
                        "${meh}+5".action.move-column-to-workspace = 5;
                        "${meh}+6".action.move-column-to-workspace = 6;

                        # Column
                        "${hyper}+U".action.consume-or-expel-window-left = [];
                        "${hyper}+I".action.consume-or-expel-window-right = [];
                        "${meh}+U".action.consume-window-into-column = [];
                        "${meh}+I".action.expel-window-from-column = [];

                        # Resize
                        "${hyper}+D".action.switch-preset-column-width = [];
                        "${hyper}+S".action.switch-preset-window-height = [];
                        "${hyper}+F".action.maximize-column = [];
                        "${hyper}+A".action.reset-window-height = [];
                        "${hyper}+G".action.fullscreen-window = [];
                        "${hyper}+V".action.expand-column-to-available-width = [];
                        "${hyper}+E".action.center-window = [];

                        "${meh}+Q".action.set-column-width = "-10%";
                        "${meh}+R".action.set-column-width = "+10%";
                        "${meh}+W".action.set-window-height = "-10%";
                        "${meh}+E".action.set-window-height = "+10%";

                        "${meh}+G".action.toggle-window-floating = [];
                        "${meh}+B".action.switch-focus-between-floating-and-tiling = [];
                        "${meh}+T".action.toggle-column-tabbed-display = [];

                    } // lib.optionalAttrs config.firefox.enable {
                        "${cms}+I".action.spawn = "${pkgs.firefox}/bin/firefox";
                    } // lib.optionalAttrs config.chromium.enable {
                        "${cam}+I".action.spawn = "${pkgs.chromium}/bin/chromium";
                    };

                    window-rules = [
                        {
                            draw-border-with-background = false;
                        }
                        {
                            matches = [
                                { title = "^Notes$"; }
                            ];
                            open-floating = true;
                            default-column-width.fixed = 1600;
                            default-window-height.fixed = 1000;
                        }
                    ];

                    prefer-no-csd = true;
                };
            };

        };
    };
}
