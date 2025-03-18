
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
	};
}
