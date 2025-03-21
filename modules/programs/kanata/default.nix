{ config, lib, ... }:

{
    services.kanata = {
        enable = true;
        keyboards = {
            main = {
                #devices = [ "/dev/input/by-id/usb-Nordic_Semiconductor_NuPhy_Air60_V2_Dongle-if01-event-kbd" ];
                devices = [  ];
                configFile = ./config.kbd;
            };
        };
    };
}
