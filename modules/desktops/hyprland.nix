{ config, lib, inputs, pkgs, userSettings, host, ... }:

let
    inherit (inputs) hyprland;
    inherit (lib) mkEnableOption mkIf;
    inherit (host) monitors;

    cfg = config.hyprland;
in
    {
    options = { hyprland.enable = mkEnableOption "Enable Hyprland"; };

    config = mkIf cfg.enable {
        wofi.enable = true;
        waybar.enable = true;

        environment = let exec = "exec dbus-launch Hyprland";
        in {

            loginShellInit = ''
            if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
                ${exec}
        fi
            '';

            variables = { };

            sessionVariables = { };

            systemPackages = with pkgs; [
                hyprpaper
                hyprcursor
                xwayland
                nwg-look

                inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
            ];
        };

        services.greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${config.programs.hyprland.package}/bin/Hyprland";
                    user = userSettings.username;
                };
                vt = 7;
            };
        };

        home-manager.users.${userSettings.username} =

            let
                lockScript = pkgs.writeShellScript "lock-script" ''
          action=$1
          ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
          if [ $? == 1 ]; then
          if [ "$action" == "lock" ]; then
          ${pkgs.hyprlock}/bin/hyprlock
          elif [ "$action" == "suspend" ]; then
          ${pkgs.systemd}/bin/systemctl suspend
          fi
          fi
          '';
            in {
                imports = [ hyprland.homeManagerModules.default ];

                programs.hyprlock = {
                    enable = true;
                };

                services.hypridle = {
                    enable = true;
                    settings = {
                        general = {
                            before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
                            after_sleep_cmd =
                                "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
                            ignore_dbus_inhibit = true;
                            lock_cmd =
                                "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
                        };
                        listener = [
                            {
                                timeout = 300;
                                on-timeout = "${lockScript.outPath} lock";
                            }
                            {
                                timeout = 1200;
                                on-timeout = "${lockScript.outPath} suspend";
                            }
                        ];
                    };
                };

                services.hyprpaper = {
                    enable = true;
                    settings = {
                        ipc = true;
                    };
                };

                wayland.windowManager.hyprland = {
                    enable = true;
                    xwayland.enable = true;

                    package = hyprland.packages.${pkgs.system}.hyprland;
                    portalPackage =
                        hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

                    plugins = [ 
                        inputs.hyprspace.packages.${pkgs.system}.Hyprspace
                    ];

                    settings = {

                        decoration = { rounding = 6; };

                        monitor = [
                            "${toString monitors.tv} ,3840x2160@119.88,1200x2160,1.0"
                            "${toString monitors.right} ,1920x1200@100.0,5040x0,1.0"
                            "${toString monitors.right},transform,3"
                            "${toString monitors.middle},3840x2160@119.88,1200x0,1.0"
                            "${toString monitors.left},1920x1200@100.0,0x0,1.0"
                            "${toString monitors.left},transform,1"
                        ];

                        env =
                            [ "HYPRCURSOR_THEME,rose-pine-hyprcursor" "HYPRCURSOR_SIZE,40" ];

                        workspace = [
                            "1, monitor:${toString monitors.middle}"
                            "2, monitor:${toString monitors.middle}"
                            "3, monitor:${toString monitors.middle}"
                            "4, monitor:${toString monitors.middle}"
                            "5, monitor:${toString monitors.left}"
                            "6, monitor:${toString monitors.left}"
                            "7, monitor:${toString monitors.right}"
                            "8, monitor:${toString monitors.right}"
                        ];

                        animations = {
                            enabled = false;
                            bezier = [
                                "overshot, 0.05, 0.9, 0.1, 1.05"
                                "smoothOut, 0.5, 0, 0.99, 0.99"
                                "smoothIn, 0.5, -0.5, 0.68, 1.5"
                                "rotate,0,0,1,1"
                            ];
                            animation = [
                                "windows, 1, 4, overshot, slide"
                                "windowsIn, 1, 2, smoothOut"
                                "windowsOut, 1, 0.5, smoothOut"
                                "windowsMove, 1, 3, smoothIn, slide"
                                "border, 1, 5, default"
                                "fade, 1, 4, smoothIn"
                                "fadeDim, 1, 4, smoothIn"
                                "workspaces, 1, 4, default"
                                "borderangle, 1, 20, rotate, loop"
                            ];
                        };

                        "$mod" = "SUPER";
                        bind = [

                            # Apps
                            "SUPER,Return,exec,${pkgs.${userSettings.terminal}}/bin/${userSettings.terminal}"
                            "SUPERSHIFT,E,exec,${pkgs.pcmanfm}/bin/pcmanfm"
                            #"SUPER,E,exec,${pkgs.pcmanfm}/bin/pcmanfm"

                            # Kill
                            "SUPER,Q,killactive,"
                            "SUPER,Escape,exit,"

                            # Power
                            "SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend"
                            "SUPER,M,exec,${pkgs.hyprlock}/bin/hyprlock"

                            # Wofi
                            "SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"

                            # Reload
                            "SUPER,R,forcerendererreload"
                            "SUPERSHIFT,R,exec,${config.programs.hyprland.package}/bin/hyprctl reload"

                            # Focus Window
                            "SUPER,h,movefocus,l"
                            "SUPER,l,movefocus,r"
                            "SUPER,k,movefocus,u"
                            "SUPER,j,movefocus,d"

                            # Move Window
                            "SUPERSHIFT,h,movewindow,l"
                            "SUPERSHIFT,l,movewindow,r"
                            "SUPERSHIFT,k,movewindow,u"
                            "SUPERSHIFT,j,movewindow,d"

                            # Switch to Workspace
                            "ALT,1,workspace,1"
                            "ALT,2,workspace,2"
                            "ALT,3,workspace,3"
                            "ALT,4,workspace,4"
                            "ALT,5,workspace,5"
                            "ALT,6,workspace,6"
                            "ALT,7,workspace,7"
                            "ALT,8,workspace,8"
                            "ALT,right,workspace,+1"
                            "ALT,left,workspace,-1"

                            # Move to Workspace
                            "ALTSHIFT,1,movetoworkspace,1"
                            "ALTSHIFT,2,movetoworkspace,2"
                            "ALTSHIFT,3,movetoworkspace,3"
                            "ALTSHIFT,4,movetoworkspace,4"
                            "ALTSHIFT,5,movetoworkspace,5"
                            "ALTSHIFT,6,movetoworkspace,6"
                            "ALTSHIFT,7,movetoworkspace,7"
                            "ALTSHIFT,8,movetoworkspace,8"
                            "ALTSHIFT,right,movetoworkspace,+1"
                            "ALTSHIFT,left,movetoworkspace,-1"

                            # Window controls
                            "SUPER,F,togglefloating,"
                            "SUPER,V,fullscreen, 1"

                            # Hyprspace
                            "SUPER,P,overview:toggle"
                        ];

                        bindm =
                            [ "SUPER,mouse:272,movewindow" "SUPER,mouse:273,resizewindow" ];

                        exec-once = [
                            "${pkgs.hyprlock}/bin/hyprlock"
                            "${pkgs.waybar}/bin/waybar -c $HOME/.config/waybar/config"
                        ];
                    };
                };
            };
    };
}
