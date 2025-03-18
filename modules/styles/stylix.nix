{ config, lib, inputs, pkgs, userSettings, ... }:
let
    inherit (userSettings) theme;
    themePath = "../../../themes"+("/" +theme+"/"+theme)+".yaml";
    themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/polarity.txt"));
    backgroundUrl = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundurl.txt");
    backgroundSha256 = builtins.readFile (./. + "../../../themes" + ("/" + theme) + "/backgroundsha256.txt");
in
    {
    stylix = {
        enable = false;
    };

    home-manager.users.${userSettings.username} = {

        imports = [ inputs.stylix.homeManagerModules.stylix ];

        stylix.polarity = themePolarity;
        stylix.image = pkgs.fetchurl {
            url = backgroundUrl;
            sha256 = backgroundSha256;
        };
        stylix.base16Scheme = ./. + themePath;

        stylix.fonts = {
            monospace = {
                name = userSettings.font;
                package = userSettings.fontPkg;
            };
            serif = {
                name = userSettings.font;
                package = userSettings.fontPkg;
            };
            sansSerif = {
                name = userSettings.font;
                package = userSettings.fontPkg;
            };
            emoji = {
                name = "Noto Emoji";
                package = pkgs.noto-fonts-monochrome-emoji;
            };
            sizes = {
                terminal = 18;
                applications = 12;
                popups = 12;
                desktop = 12;
            };
        };
    };
}
