
{ config, lib, pkgs, hyprland, vars, hosts, ... }:

let 
colors = import ../styles/colors.nix;
cfg = config.hyprland;
in
with lib;
{
	options = {
		hyprland.enable = mkEnableOption "Enable Hyprland";
	};

	config = mkIf cfg.enable {
		wlwm.enable = true;

		environment =
			let
			exec = "exec dbus-launch Hyprland";
		in
		{

			loginShellInit = ''
				if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
					${exec}
			fi
				'';

			variables = {
			};

			sessionVariables = {
			};

			systemPackages = with pkgs; [
			];
		};

		services.greetd = {
			enable = true;
			settings = {
				default_session = {
					command = "${config.programs.hyprland.package}/bin/Hyprland";
					user = vars.user.name;
				};
				vt = 7;
			};
		};

		home-manager.users.${vars.user.name} = 

			let
			lockScript = pkgs.writeShellScript "lock-script" ''
			action=$1
			${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
			if [ $? == 1 ]; then
				if [ "$action" == "lock" ]; then
					${pkgs.hyprlock}/bin/hyprlock
				elif [ "$action" == "suspend" ]; then
					${pkgs.systemd}/bin/systemctl suspend
				fi
			fi
			'';
			in
			{

				programs.hyprlock = {
					enable = true;
					settings = {
						background = [{
							monitor = "";
							path = "$HOME/.config/media/wall.png";
							color = "rgba(25, 20, 20, 1.0)";
							blur_passes = 1;
							blur_size = 0;
							brightness = 0.2;
						}];
						input-field = [
						{
							monitor = "";
							size = "250, 60";
							outline_thickness = 2;
							dots_size = 0.2;
							dots_spacing = 0.2;
							dots_center = true;
							outer_color = "rgba(0, 0, 0, 0)";
							inner_color = "rgba(0, 0, 0, 0.5)";
							font_color = "rgb(200, 200, 200)";
							fade_on_empty = false;
							placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
							hide_input = false;
							position = "0, -120";
							halign = "center";
							valign = "center";
						}
						];
						label = [
						{
							monitor = "";
							text = "$TIME";
							font_size = 120;
							position = "0, 80";
							valign = "center";
							halign = "center";
						}
						];
					};
				};

				services.hypridle = {
					enable = true;
					settings = {
						general = {
							before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
							after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
							ignore_dbus_inhibit = true;
							lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
						};
						listener = [
						{
							timeout = 300;
							on-timeout = "${lockScript.outPath} lock";
						}
						{
							timeout = 1800;
							on-timeout = "${lockScript.outPath} suspend";
						}
						];
					};
				};

				wayland.windowManager.hyprland = {
					enable = true;
					xwayland.enable = true;

					package = hyprland.packages.${pkgs.system}.hyprland;
					portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

					settings = {

						decoration = {
							rounding = 6;
						};

						monitor = [
							"HDMI-A-2, 3840x2160@120, 0x0, 1"
								"DP-2, 1920x1200@100, -3840x0, 1, transform, 3"
								"DP-2, 1920x1200@100, 3840x0, 1, transform, 1"
						];

						"$mod" = "SUPER";
						bind = [
							"SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}"
								"SUPER,Q,killactive,"
								"SUPER,Escape,exit,"
								"SUPER,F,togglefloating,"
								"SUPER,h,movefocus,l"
								"SUPER,l,movefocus,r"
								"SUPER,k,movefocus,u"
								"SUPER,j,movefocus,d"
								"SUPERSHIFT,h,movewindow,l"
								"SUPERSHIFT,l,movewindow,r"
								"SUPERSHIFT,k,movewindow,u"
								"SUPERSHIFT,j,movewindow,d"
						];

						exec-once = [
							
						];
					};
				};
			};

	};
}


