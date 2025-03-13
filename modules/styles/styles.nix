
{ vars, ... }:

{
	home-manager.users.${vars.user.name} = {
		home = {
			file = {
				".config/media".source = ./media;
			};
		};
	};
}
