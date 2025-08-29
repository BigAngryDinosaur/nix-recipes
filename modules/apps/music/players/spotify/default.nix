{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.spotify;
in
{
    options = {
        spotify.enable = mkEnableOption "Enable Spotify";
    };

    config = mkIf cfg.enable {
	home-manager.users.${userSettings.username} = {
		home = {
			packages = with pkgs; [
				spotify
			];
		};

	};
    };
}

