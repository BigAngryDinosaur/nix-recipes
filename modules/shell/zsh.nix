
{ pkgs, vars, ... }:

{
  users.users.${vars.user.name} = {
    shell = pkgs.zsh;
  };

  home-manager.users.${vars.user.name} = {
  	home = {
		packages = with pkgs; [
			eza
			fd
			jq
			bat
		];
	};
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 100000;

      ohMyZsh = {
        enable = true;
	theme = "robbyrussell";
        plugins = [ "git" "eza" ];
      };

      shellInit = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
      '';
    };
  };
}
