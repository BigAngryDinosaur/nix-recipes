{ config, pkgs, ... }: {

    environment.systemPackages = [
        pkgs.stremio
    ];
}
