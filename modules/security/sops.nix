{ config, lib, inputs, userSettings, ... }:
let
    secretsFile = ../../secrets/secrets.yaml;
    keyFile = "${config.users.users.${userSettings.username}.home}/.config/sops/age/keys.txt";
in
{
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];

    sops = {
        defaultSopsFile = secretsFile;
        age.keyFile = keyFile;

        secrets."gemini_cli/api_key" = {};
        secrets."nix/github_pat" = {
            owner = "root";
            group = "root";
            mode = "0440";
        };
    };

    # Configure nix to use GitHub PAT from sops
    nix.extraOptions = ''
        access-tokens = github.com=${config.sops.secrets."nix/github_pat".path}
    '';
}
