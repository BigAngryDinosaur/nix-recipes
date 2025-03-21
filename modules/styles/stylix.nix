{ config, lib, inputs, pkgs, userSettings, ... }:
let
    inherit (userSettings) theme;
    themePath = "../../../themes"+("/" +theme+"/"+theme)+".yaml";
    themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/polarity.txt"));
    backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundurl.txt");
    backgroundSha256 = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundsha256.txt");
in
    {
    home-manager.users.${userSettings.username} = {

        stylix.enable = true;
        stylix.polarity = themePolarity;
        stylix.image = pkgs.fetchurl {
            url = backgroundUrl;
            sha256 = backgroundSha256;
        };
        stylix.base16Scheme = ./. + themePath;

        stylix.fonts = {
            monospace = {
                name = userSettings.font.name;
                package = userSettings.font.pkg;
            };
            serif = {
                name = userSettings.font.name;
                package = userSettings.font.pkg;
            };
            sansSerif = {
                name = userSettings.font.name;
                package = userSettings.font.pkg;
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

        fonts.fontconfig.defaultFonts = {
            monospace = [ userSettings.font.name ];
            sansSerif = [ userSettings.font.name ];
            serif = [ userSettings.font.name ];
        };

        stylix.cursor.package = pkgs.bibata-cursors;
        stylix.cursor.name = "Bibata-Modern-Amber";
        stylix.cursor.size = 24;

        stylix.opacity = {
            terminal = 0.9;
            desktop = 0.5;
        };

        stylix.targets.niri.enable = true;

        stylix.targets.nixvim = {
            transparentBackground = {
                main = true;
                signColumn = true;
            };
        };
    };
}
