
{ config, lib, pkgs, userSettings, host, ... }:

let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.waybar;
in
    {
    options = {
        waybar.enable = mkEnableOption "Enable Waybar";
    };

    config = mkIf cfg.enable {

        home-manager.users.${userSettings.username} = let 
                icons = rec {
                    calendar = "󰃭 ";
                    clock = " ";
                    battery.charging = "󱐋";
                    battery.horizontal = [" " " " " " " " " "];
                    battery.vertical = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                    battery.levels = battery.vertical;
                    network.disconnected = "󰤮 ";
                    network.ethernet = "󰈀 ";
                    network.strength = ["󰤟 " "󰤢 " "󰤥 " "󰤨 "];
                    bluetooth.on = "󰂯";
                    bluetooth.off = "󰂲";
                    bluetooth.battery = "󰥉";
                    volume.source = "󱄠";
                    volume.muted = "󰝟";
                    volume.levels = ["󰕿" "󰖀" "󰕾"];
                    idle.on = "󰈈 ";
                    idle.off = "󰈉 ";
                }; in
                {
                programs.waybar = {
                    enable = true;
                    package = pkgs.waybar;

                    settings = {
                        mainBar = {
                            layer = "top";
                            modules-left = [
                                "image"
                                "niri/workspaces"
                                "idle_inhibitor"
                                "niri/window"
                            ];
                            modules-center = ["clock#date" "clock"];
                            modules-right = ["network" "bluetooth" "battery"];

                            battery = {
                                interval = 5;
                                format = "{icon}  {capacity}%";
                                format-charging = "{icon}  {capacity}% ${icons.battery.charging}";
                                format-icons = icons.battery.levels;
                                states.warning = 30;
                                states.critical = 15;
                            };

                            clock = {
                                interval = 1;
                                format = "${icons.clock} {:%H:%M:%S}";
                            };

                            "clock#date" = {
                                format = "${icons.calendar} {:%Y-%m-%d}";
                            };

                            network = {
                                tooltip-format = "{ifname}";
                                format-disconnected = icons.network.disconnected;
                                format-ethernet = icons.network.ethernet;
                                format-wifi = "{icon} {essid}";
                                format-icons = icons.network.strength;
                            };

                            bluetooth = {
                                format = "{icon}";
                                format-disabled = "";
                                format-icons = {
                                    inherit (icons.bluetooth) on off;
                                    connected = icons.bluetooth.on;
                                };
                                format-connected = "{icon} {device_alias}";
                            };

                            idle_inhibitor = {
                                format = "{icon}";
                                format-icons = {
                                    activated = icons.idle.on;
                                    deactivated = icons.idle.off;
                                };
                            };
                        };
                    };

                };
            };
    };
}
