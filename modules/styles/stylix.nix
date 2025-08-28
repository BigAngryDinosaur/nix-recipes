{ config, lib, inputs, pkgs, userSettings, ... }:
let
    inherit (userSettings) theme;
    themePath = "../../../themes"+("/" +theme+"/"+theme)+".yaml";
    themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/polarity.txt"));
    backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundurl.txt");
    backgroundSha256 = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundsha256.txt");
    font = {
	name = "JetBrains Mono Nerd Font";
        pkg = pkgs.nerd-fonts.jetbrains-mono;
    };
in
{
    stylix = {
        enable = true;
        polarity = themePolarity;
        image = pkgs.fetchurl {
            url = backgroundUrl;
            sha256 = backgroundSha256;
        };
        base16Scheme = ./. + themePath;
        fonts = {
            monospace = {
                name = font.name;
                package = font.pkg;
            };
            serif = {
                name = font.name;
                package = font.pkg;
            };
            sansSerif = {
                name = font.name;
                package = font.pkg;
            };
            emoji = {
                name = "Noto Emoji";
                package = pkgs.noto-fonts-monochrome-emoji;
            };
            sizes = {
                terminal = 12;
                applications = 12;
                popups = 12;
                desktop = 12;
            };
        };
        cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Amber";
            size = 24;
        };
        opacity = {
            terminal = 0.9;
            desktop = 0.5;
        };
        
        homeManagerIntegration = {
            autoImport = true;
            followSystem = true;
        };
    };

    home-manager.users.${userSettings.username} = {
        fonts.fontconfig.defaultFonts = {
            monospace = [ font.name ];
            sansSerif = [ font.name ];
            serif = [ font.name ];
        };
        
        stylix.targets.niri.enable = true;

        stylix.targets.firefox.profileNames = [ "default" ];
        
        stylix.targets.nixvim = {
            transparentBackground = {
                main = true;
                signColumn = true;
            };
        };
    };
}

