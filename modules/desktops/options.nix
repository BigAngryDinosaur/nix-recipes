
{ lib, ... }:

with lib;
{
	options = {
		wlwm = mkEnableOption "Enable Wayland";
	};
}
