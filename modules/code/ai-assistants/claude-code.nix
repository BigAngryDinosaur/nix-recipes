{ config, lib, pkgs, inputs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.claude-code;
in
{
    options = {
        claude-code.enable = mkEnableOption "Enable Claude Code AI assistant";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            home.packages = [
                inputs.claude-code-nix.packages.${pkgs.system}.default
            ];
        };
    };
}