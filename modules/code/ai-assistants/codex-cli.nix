{ config, lib, pkgs, inputs, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.codex-cli;

    codexConfig = ''
        model = "openai/gpt-5.2-codex"
        model_provider = "openrouter"

        [model_providers.openrouter]
        name = "OpenRouter"
        base_url = "https://openrouter.ai/api/v1"
        env_key = "OPENROUTER_API_KEY"
        wire_api = "responses"
    '';
in
{
    options = {
        codex-cli.enable = mkEnableOption "Enable OpenAI Codex CLI";
    };

    config = mkIf cfg.enable {
        sops.secrets."openrouter/api_key" = {};
        sops.secrets."openrouter/api_key".owner = userSettings.username;

        home-manager.users.${userSettings.username} = {
            home.packages = [
                inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];

            home.file.".codex/config.toml".text = codexConfig;

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
