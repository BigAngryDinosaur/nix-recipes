
{ config, lib, pkgs, inputs, userSettings, host, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    inherit (host) monitors;

    cfg = config.niri;
in
{
    options = {
        niri.enable = mkEnableOption "Enable Niri";
    };

    config = mkIf cfg.enable {
        wlwm.enable = true;

        services.greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.niri}/bin/niri-session";
                    user = userSettings.username;
                };
                vt = 7;
            };
        };

        home-manager.users.${userSettings.username} = {

            nixpkgs.overlays = [
                inputs.niri.overlays.niri
            ];

            imports = [
                inputs.niri.homeModules.niri
            ];

            programs.niri = {
                enable = true;
                package = pkgs.niri;

                outputs = {
                    "${toString monitors.left}" = {
                        scale = 1.0;
                        transform.rotation = 90; 
                        mode = {
                            width = 1920;
                            height = 1200;
                            refresh = 100.0;
                        };
                        position = {
                            x = 0;
                            y = 0;
                        };
                    };
                    "${toString monitors.tv}" = {
                        scale = 1.50;
                        mode = {
                            width = 3840;
                            height = 2160;
                            refresh = 119.88;
                        };
                        position = {
                            x = 1920;
                            y = 0;
                        };
                    };
                    "${toString monitors.right}" = {
                        scale = 1.0;
                        transform.rotation = 270; 
                        mode = {
                            width = 1920;
                            height = 1200;
                            refresh = 100.0;
                        };
                        position = {
                            x = 4480;
                            y = 0;
                        };
                    };
                };
            };

            layout = {
                focus-ring = {
                    width = 4;
                    active.gradient = {
                        to=config.theme.rose;
                        from=config.theme.pine;
                        angle=135;
                    };
                    inactive.color = config.theme.iris;
                };

                preset-column-widths = [
                    { proportion = 0.25; }
                    { proportion = 0.5; }
                    { proportion = 0.75; }
                ];

                default-column-width = { proportion = 0.5; };
                gaps = 16;
            };
        };
    };
}
