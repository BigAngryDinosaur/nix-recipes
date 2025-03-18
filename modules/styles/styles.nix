
{ pkgs, userSettings, ... }:

{
	home-manager.users.${userSettings.username} = {
		home = {
		};
	};
}
