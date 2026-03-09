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
        sops.secrets."openrouter/api_key" = {};
        sops.secrets."openrouter/api_key".owner = userSettings.username;

        home-manager.users.${userSettings.username} = {
            home.packages = [
                inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            programs.zsh.envExtra = ''
                if [[ -f "${config.sops.secrets."openrouter/api_key".path}" ]]; then
                    export OPENROUTER_API_KEY="$(cat ${config.sops.secrets."openrouter/api_key".path})"
                    export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
                    export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
                    export ANTHROPIC_API_KEY=""
                fi
            '';
            programs.nushell.extraEnv = ''
                if ('${config.sops.secrets."openrouter/api_key".path}' | path exists) {
                    $env.OPENROUTER_API_KEY = (open '${config.sops.secrets."openrouter/api_key".path}' | str trim)
                    $env.ANTHROPIC_BASE_URL = "https://openrouter.ai/api"
                    $env.ANTHROPIC_AUTH_TOKEN = $env.OPENROUTER_API_KEY
                    $env.ANTHROPIC_API_KEY = ""
                }
            '';
        };
    };
}