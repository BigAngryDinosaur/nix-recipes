{ pkgs, lib, userSettings, ... }:

{
    imports = [
        ./hyprland.nix
        ./niri.nix
        ./wofi.nix
        ./swww.nix
        ./waybar.nix
        ./hyprpaper.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./greetd.nix
    ];

    environment = {
        variables = {
            NIXOS_OZONE_WL = "1";
        };
    };

    home-manager.users.${userSettings.username} = {

        home = {
            packages = with pkgs; [
                wl-clipboard
                wayland-utils
            ];

            sessionVariables = {
                QT_QPA_PLATFORM = "wayland";
                SDL_VIDEODRIVER = "wayland";
                XDG_SESSION_TYPE = "wayland";
            };
        };
    };
}
