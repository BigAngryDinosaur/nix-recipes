{ config, lib, pkgs, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.stremio;
in
{
    options = {
        stremio.enable = mkEnableOption "Enable Stremio";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [
            pkgs.stremio
        ];
    };
}
