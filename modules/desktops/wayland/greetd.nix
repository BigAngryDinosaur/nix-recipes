{ pkgs, lib, config, userSettings, ... }:
let
    command = 
    if config.hyprland.enable then
        "${config.programs.hyprland.package}/bin/Hyprland"
    else if config.niri.enable then
        "${pkgs.niri}/bin/niri-session"
    else
        abort "Invalid WM";
in
{
    services.greetd = let
        session = {
            command = command;
            user = userSettings.username;
        };
        in {
        enable = true;
        settings = {
            default_session = session;
            initial_session = session;
            terminal.vt = 7;
        };
    };
}
