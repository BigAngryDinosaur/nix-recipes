{ config, lib, inputs, pkgs, userSettings, ... }:

{
    home-manager.users.${userSettings.username} = {

        imports = [ inputs.nixvim.homeModules.nixvim ];

        programs.nixvim = {
            enable = true;

            viAlias = true;
            vimAlias = true;

            opts = import ./options.nix;
            globals = import ./globals.nix;
            keymaps = import ./keymaps.nix;
            plugins = import ./plugins.nix { inherit pkgs; };
        };
    };
}