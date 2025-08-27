{ config, pkgs, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        keyd.enable = mkEnableOption "Enable keyd";
    };

    config = mkIf config.keyd.enable {
        services.keyd = {
            enable = true;
            keyboards = {
                default = {
                    ids = [ "*" ];
                    settings = {
                        alt = {
                            insert = "C-a";
                        };
                        control = {
                            insert = "C-c";
                        };
                        meta = {
                            insert = "C-v";
                        };
                    };
                    extraConfig = ''
                        [alt+meta]
                        insert = C-q

                        [shift]
                        insert = C-t

                        [control]
                        delete = C-z

                        [control+shift]
                        insert = C-w
                        delete = C-S-z
                    '';
                };
            };
        };

        users.groups.keyd = {};
        users.users.${userSettings.username}.extraGroups = [ "keyd" ];

        home-manager.users.${userSettings.username} = {
            home.file.".config/keyd/app.conf".text = ''
                [com-mitchellh-ghostty]
                control.insert = C-S-c
                meta.insert = C-S-v

            '';
            
            systemd.user.services.keyd-application-mapper = {
                Unit = {
                    Description = "keyd application mapper";
                    PartOf = [ "graphical-session.target" ];
                    After = [ "graphical-session.target" ];
                };
                Install = {
                    WantedBy = [ "graphical-session.target" ];
                };
                Service = {
                    Type = "simple";
                    ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
                };
            };
        };

        systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
            "CAP_SETGID"                                               
        ];

        environment.systemPackages = with pkgs; [
            keyd
        ];
    };
}
