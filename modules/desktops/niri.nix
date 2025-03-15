
{ config, lib, pkgs, inputs, vars, host, ... }:

let
cfg = config.niri;
in
with lib;
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
					user = vars.user.name;
				};
				vt = 7;
			};
		};

		home-manager.users.${vars.user.name} = {

			imports = [
				inputs.niri.homeModules.niri
			];

			programs.niri = {
				enable = true;
				package = pkgs.niri;

				settings = {
				        binds = {

						"Mod+Return".action.spawn = "${pkgs.${vars.terminal}}/bin/${vars.terminal}";
						"Mod+Q".action = close-window;
						"Mod+S".action = switch-preset-column-width;
						"Mod+F".action = maximize-column;
						"Mod+Space".action = spawn "${pkgs.wofi}/bin/wofi --show drun";

						"Mod+Shift+F".action = expand-column-to-available-width;
						"Mod+Shift+Space".action = toggle-window-floating;
						"Mod+W".action = toggle-column-tabbed-display;

						"Mod+Comma".action = consume-window-into-column;
						"Mod+Period".action = expel-window-from-column;
						"Mod+C".action = center-window;
						"Mod+Tab".action = switch-focus-between-floating-and-tiling;

						"Mod+Minus".action = set-column-width "-10%";
						"Mod+Plus".action = set-column-width "+10%";
						"Mod+Shift+Minus".action = set-window-height "-10%";
						"Mod+Shift+Plus".action = set-window-height "+10%";

						"Mod+H".action = focus-column-left;
						"Mod+L".action = focus-column-right;
						"Mod+J".action = focus-window-or-workspace-down;
						"Mod+K".action = focus-window-or-workspace-up;
						"Mod+Left".action = focus-column-left;
						"Mod+Right".action = focus-column-right;
						"Mod+Down".action = focus-workspace-down;
						"Mod+Up".action = focus-workspace-up;

						"Mod+Shift+H".action = move-column-left;
						"Mod+Shift+L".action = move-column-right;
						"Mod+Shift+K".action = move-column-to-workspace-up;
						"Mod+Shift+J".action = move-column-to-workspace-down;

						"Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
						"Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
					};
				};
			};
		};
	};
}
