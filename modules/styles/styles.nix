
{ pkgs, userSettings, ... }:

{
	home-manager.users.${userSettings.username} = {
		home = {
			file = {
				".config/media".source = ./media;
			};

			pointerCursor = {
				gtk.enable = true;
				package = pkgs.rose-pine-cursor;
				name = "BreezeX-RosePine-Linux";
				size = 40;
			};
		};

		gtk = {
			enable = true;
			theme = {
				name = "Orchis-Dark-Compact";
				package = pkgs.orchis-theme;
			};
			iconTheme = {
				name = "Papirus-Dark";
				package = pkgs.papirus-icon-theme;
			};
			font = {
				name = "FiraCode Nerd Font Mono Medium";
			};
		};

	};
}
