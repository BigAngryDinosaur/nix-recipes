{ config, lib, pkgs, userSettings, ... }: 
let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.chromium;
in
{
    options = {
        chromium.enable = mkEnableOption "Chromium browser";
    };

    config = mkIf cfg.enable {
        home-manager.users.${userSettings.username} = {
            programs.chromium = {
                enable = true;
                package = pkgs.chromium;
                extensions = [
                    { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
                    { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
                    { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
                    { id = "mgijmajocgfcbeboacabfgobmjgjcoja"; } # Google Dictionary
                    { id = "bgnkhhnnamicmpeenaelnjfhikgbkllg"; } # AdGuard AdBlocker
                    { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # Reddit Enhancement Suite
                    { id = "dneaehbmnbhcippjikoajpoabadpodje"; } # Old Reddit Redirect
                    { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # Grammarly
                    { id = "jlgkpaicikihijadgifklkbpdajbkhjo"; } # CrxMouse Gestures
                ];
            };
        };
    };
}
