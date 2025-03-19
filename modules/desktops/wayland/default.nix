{ pkgs, lib, userSettings, ... }:

{
    imports = [
        ./hyprland.nix
        ./niri.nix
        ./wofi.nix
        ./waybar.nix
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

    programs.uwsm = {
        enable = true;
        waylandCompositors = {
            niri = {
                binPath = "${pkgs.niri}/bin/niri-session";
                prettyName = "Niri";
                comment = "Niri managed by UWSM";
            };
            hyprland = {
                binPath = "/run/current-system/sw/bin/hyprland";
                prettyName = "Hyprland";
                comment = "Hyprland managed by UWSM";
            };
        };
    };
}
