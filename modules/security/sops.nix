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
    };
}
