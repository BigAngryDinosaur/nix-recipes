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
        secrets."openrouter/api_key" = {};
        secrets."nix/github_pat" = {
            group = "nixbld";
            mode = "0440";
        };
        secrets."nix/github_username" = {
            group = "nixbld";
            mode = "0440";
        };
    };

    # Configure nix to use netrc file
    nix.settings.netrc-file = "/run/secrets/netrc";
    
    # Create systemd service to generate netrc from sops secrets
    systemd.services.generate-netrc = {
        description = "Generate netrc file from sops secrets";
        wantedBy = [ "multi-user.target" ];
        after = [ "sops-nix.service" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "root";
            Group = "root";
        };
        script = ''
            mkdir -p /run/secrets
            cat > /run/secrets/netrc << EOF
machine github.com
login $(cat ${config.sops.secrets."nix/github_username".path})
password $(cat ${config.sops.secrets."nix/github_pat".path})
EOF
            chmod 644 /run/secrets/netrc
            chown root:nixbld /run/secrets/netrc
        '';
    };
}
