{ config, lib, pkgs, inputs, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.swww;
in
{
    options = {
        swww.enable = mkEnableOption "Enable swww";
    };

    config = mkIf cfg.enable {
        
        environment.systemPackages = [
            inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
        ];
    };
}
