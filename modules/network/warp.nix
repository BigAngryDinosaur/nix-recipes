{ config, lib, pkgs, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        warp.enable = mkEnableOption "Enable Cloudflare Warp";
    };

    config = mkIf config.warp.enable {
        environment.systemPackages = [
            pkgs.cloudflare-warp
        ];

        systemd.packages = [
            pkgs.cloudflare-warp
        ];

        systemd.targets.multi-user.wants = [ "warp-svc.service" ];
    };
}
