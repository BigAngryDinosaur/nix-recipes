{ pkgs, userSettings, ... } : {
	
	home-manager.users.${userSettings.username} = {

		home = {
			packages = with pkgs; [
				spotify
			];
		};

	};
}
