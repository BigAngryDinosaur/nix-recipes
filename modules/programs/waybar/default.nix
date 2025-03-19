
{ config, lib, pkgs, userSettings, host, ... }:

let
    colors = import ../../styles/colors.nix;

    inherit (lib) mkEnableOption mkIf;

    cfg = config.waybar;
in
{
    options = {
        waybar.enable = mkEnableOption "Enable Waybar";
    };

	config = mkIf cfg.enable {

		home-manager.users.${userSettings.username} = with colors.scheme.default; {
			programs.waybar = {
				enable = true;
				package = pkgs.waybar;

				settings = {
					Main = {
						layer = "top";
						position = "top";
						height = 27;

						tray = { spacing = 5; };

						modules-left = [
							"custom/menu"
								"hyprland/workspaces"
						];

						modules-right = [
							"network"
								"cpu"
								"memory"
								"pulseaudio"
								"clock"
								"tray"
						];

						"custom/menu" = {
							format = "<span font='16'></span>";
							on-click = ''sleep 0.1; .config/wofi/power.sh'';
							on-click-right = "sleep 0.1; ${pkgs.wofi}/bin/wofi --show drun";
							tooltip = false;
						};

						"hyprland/workspaces" = {
							format = "<span font='11'>{name}</span>";
							window-rewrite = { };
						};

						clock = {
							format = "{:%b %d %H:%M}  ";
						};
						cpu = {
							format = " {usage}% <span font='11'></span> ";
							interval = 1;
						};
						disk = {
							format = "{percentage_used}% <span font='11'></span>";
							path = "/";
							interval = 30;
						};
						memory = {
							format = "{}% <span font='11'></span>";
							interval = 1;
						};
						battery = {
							interval = 1;
							states = {
								warning = 30;
								critical = 15;
							};
							format = "{capacity}% <span font='11'>{icon}</span>";
							format-charging = "{capacity}% <span font='11'></span>";
							format-icons = [ "" "" "" "" "" ];
							max-length = 25;
						};
						network = {
							format-wifi = "<span font='11'></span>";
							format-ethernet = "<span font='11'>󰈀</span>";
							format-linked = "<span font='11'>󱘖</span> {ifname} (No IP)";
							format-disconnected = "<span font='11'>󱘖</span> Not connected";
							tooltip-format = "{essid} {ipaddr}/{cidr}";
						};
						pulseaudio = {
							format = "<span font='13'>{icon}</span> {volume}% {format_source} ";
							format-bluetooth = "<span font='13'>{icon}</span> {volume}% {format_source} ";
							format-bluetooth-muted = "<span font='13'>x</span> {volume}% {format_source} ";
							format-muted = "<span font='13'>x</span> {volume}% {format_source} ";
							format-source = "<span font='14'></span> ";
							format-source-muted = "<span font='14'></span> ";
							format-icons = {
								default = [ "" "" "" ];
								headphone = "";
							};
							tooltip-format = "{desc}, {volume}%";
							scroll-step = 5;
							on-click = "${pkgs.pamixer}/bin/pamixer -t";
							on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
							on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
						};
					};

				};

				style = ''
					* {
					border: none;
					border-radius: 0;
					font-family: FiraCode Nerd Font Mono;
					font-size: 12px;
					text-shadow: 0px 0px 5px #000000;
										}
					button:hover {
						       background-color: rgba(${rgb.active},0.4);
					       }
					       window#waybar {
						       background-color: rgba(0, 0, 0 , 0.5);
						       transition-property: background-color;
						       transition-duration: .5s;
						       border-bottom: 1px solid rgba(${rgb.active}, 0.99);
					       }
					       window#waybar.hidden {
					opacity: 0.2;
					       }
					#workspace,
					#mode,
					#clock,
					#pulseaudio,
					#network,
					#mpd,
					#memory,
					#network,
					#window,
					#cpu,
					#disk,
					#battery,
					#tray {
					color: #${hex.text};
					       background-clip: padding-box;
					}
					#custom-menu {
					color: rgba(255, 255, 255, 0.9);
					padding: 0px 5px 0px 5px;
					}
					#workspaces button {
					padding: 0px 7px;
						 min-width: 5px;
					color: rgba(${rgb.text},1);
					}
					#workspaces button:hover {
						background-color: rgba(0,0,0,0.2);
					}
					#workspaces button.visible {
						background-color: rgba(${rgb.active}, 0.3);
					}
					/*#workspaces button.focused {*/
					#workspaces button.active {
					color: rgba(${rgb.fg},1);
					       background-color: rgba(${rgb.active}, 0.8);
					}
					#workspaces button.hidden {
					color: #${hex.text};
					}
					#battery.warning {
					color: #ff5d17;
					       background-color: rgba(0,0,0,0);
					}
					#battery.critical {
					color: #ff200c;
					       background-color: rgba(0,0,0,0);
					}
					#battery.charging {
					color: #9ece6a;
					       background-color: rgba(0,0,0,0);
					}
					'';
			};
		};
	};
}
