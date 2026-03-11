{ config, lib, pkgs, inputs, ... }:
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.awww;
in
{
    options = {
        awww.enable = mkEnableOption "Enable awww";
    };

    config = mkIf cfg.enable {
        
        environment.systemPackages = [
            inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
        ];
    };
}
