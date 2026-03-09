{ config, lib, pkgs, inputs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.pi;

    piAuthConfig = builtins.toJSON {
        openrouter = {
            type = "api_key";
            key = "!cat ${config.sops.secrets."openrouter/api_key".path}";
        };
    };
in
{
    options = {
        pi.enable = mkEnableOption "Enable Pi coding agent";
    };

    config = mkIf cfg.enable {
        sops.secrets."openrouter/api_key" = {};
        sops.secrets."openrouter/api_key".owner = userSettings.username;

        home-manager.users.${userSettings.username} = {
            home.packages = [
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
            ];

            home.file.".pi/agent/auth.json".text = piAuthConfig;

            programs.zsh.envExtra = ''
                if [[ -f "${config.sops.secrets."openrouter/api_key".path}" ]]; then
                    export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/api_key".path})"
                fi
            '';
            programs.nushell.extraEnv = ''
                if ('${config.sops.secrets."openrouter/api_key".path}' | path exists) {
                    $env.OPENROUTER_API_KEY = (cat '${config.sops.secrets."openrouter/api_key".path}')
                }
            '';
        };
    };
}
