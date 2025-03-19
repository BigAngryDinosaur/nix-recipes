{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) getExe;

    hyprlockExe = getExe config.programs.hyprlock.package;

    # Lock Script
    lockScript = pkgs.writeShellScript "lock-script" ''
              action=$1
              ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
              if [ $? == 1 ]; then
              if [ "$action" == "lock" ]; then
              ${hyprlockExe}
              elif [ "$action" == "suspend" ]; then
              ${pkgs.systemd}/bin/systemctl suspend
              fi
              fi
              '';

in {

    home-manager.users.${userSettings.username} = {
        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
                    ignore_dbus_inhibit = true;
                    lock_cmd = hyprlockExe;
                };
                listener = [
                    {
                        timeout = 30;
                        on-timeout = "${lockScript.outPath} lock";
                    }
                    {
                        timeout = 300 + 10;
                        on-timeout = "${lockScript.outPath} suspend";
                    }
                ];
            };
        };
    };
}
