{ inputs, pkgs, userSettings, ... }:

{
  home-manager.users.${userSettings.username} = {
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
