{ inputs, pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home = {
      packages = with pkgs; [
        inputs.ghostty.packages.${pkgs.system}.default
      ];
      file = {
        ".config/ghostty".source = ./config;
      };
    };
  };
}
