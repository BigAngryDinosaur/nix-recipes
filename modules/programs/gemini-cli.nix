{ config, lib, pkgs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        gemini-cli.enable = mkEnableOption "Enable Gemini CLI";
    };
    
    config = mkIf config.gemini-cli.enable {
        environment.systemPackages = [
            pkgs.gemini-cli
        ];

        sops.secrets."gemini_cli/api_key" = {};
        sops.secrets."gemini_cli/api_key".owner = userSettings.username;

        home-manager.users.${userSettings.username} = {
            programs.zsh.envExtra = ''
                if [[ -f "${config.sops.secrets."gemini_cli/api_key".path}" ]]; then
                    export GEMINI_API_KEY="$(cat ${config.sops.secrets."gemini_cli/api_key".path})"
                fi
            '';
            programs.nushell.extraEnv = ''
                if ('${config.sops.secrets."gemini_cli/api_key".path}' | path exists) {
                    $env.GEMINI_API_KEY = (cat '${config.sops.secrets."gemini_cli/api_key".path}')
                }
            '';
        };
    };
}
