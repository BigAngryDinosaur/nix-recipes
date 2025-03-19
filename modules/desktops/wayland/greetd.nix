{ pkgs, lib, config, userSettings, ... }:
let
    command = 
    if config.hyprland.enable then
        "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop"
    else if config.niri.enable then
        "${lib.getExe config.programs.uwsm.package} start ${pkgs.niri}/share/wayland-sessions/niri.desktop"
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
