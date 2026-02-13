{ config, lib, pkgs, userSettings, inputs, ... }:
let
    inherit (lib) mkEnableOption mkIf;
in
{
    options = {
        ohmyposh.enable = mkEnableOption "Enable oh-my-posh";
    };

    config = mkIf config.ohmyposh.enable {
        home-manager.users.${userSettings.username} = {
            programs.oh-my-posh = {
                enable = true;
                enableNushellIntegration = mkIf config.nushell.enable true;
                settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile (./. + "/themes/pure.json")));
            };

            # Clean up stale oh-my-posh init files from nushell vendor/autoload
            # These versioned files (init.*.nu) are left behind after upgrades
            # and reference old Nix store paths that no longer exist
            home.activation.cleanOhMyPoshNushellCache = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                rm -f $HOME/.local/share/nushell/vendor/autoload/init.*.nu
            '';
        };
    };
}
