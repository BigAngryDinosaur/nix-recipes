{ config, lib, pkgs, inputs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.antigravity;
in
{
    options = {
        antigravity.enable = mkEnableOption "Enable Google Antigravity AI assistant";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            home.packages = [
                inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
        };
    };
}
