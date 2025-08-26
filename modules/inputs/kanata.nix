{ config, pkgs, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf mkOption types;
in
{
    options = {
        kanata.enable = mkEnableOption "Enable kanata keyboard customization";
        kanata.port = mkOption {
            type = types.port;
            default = 10000;
            description = "TCP port for kanata server (required for hyprkan)";
        };
    };

    config = mkIf config.kanata.enable {
        # Enable uinput kernel module
        boot.kernelModules = [ "uinput" ];
        
        # Enable uinput hardware support
        hardware.uinput.enable = true;
        
        # Set up udev rules for uinput
        services.udev.extraRules = ''
            KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
        '';
        
        # Ensure the uinput group exists
        users.groups.uinput = { };
        
        # Add user to input and uinput groups
        users.users.${userSettings.username}.extraGroups = [ "input" "uinput" ];

        # Configure Kanata service
        services.kanata = {
            enable = true;
            keyboards = {
                main = {
                    # Auto-detect keyboards - you may need to specify specific devices
                    devices = [ ];
                    
                    # Enable TCP server for hyprkan integration
                    port = config.kanata.port;
                    
                    # Custom keybinding configuration
                    config = ''
                        (defsrc
                            caps a s d f g h j k l ; '
                            lsft z x c v b n m , . /
                            lalt lmet lctl ralt rmet rctl rsft
                            ins del
                        )

                        (defalias
                            ;; Layer-aware actions using switch
                            ctrl-ins (switch
                                ((layer ghostty)) C-S-c break    ;; ctrl+shift+c on ghostty
                                () C-c break                     ;; ctrl+c on other layers
                            )
                            meta-ins (switch
                                ((layer ghostty)) C-S-v break    ;; ctrl+shift+v on ghostty
                                () C-v break                     ;; ctrl+v on other layers
                            )
                        )

                        ;; Global key combination definitions using defchordsv2
                        (defchordsv2
                            (lalt ins) C-a          200 first-release ()     ;; alt + insert = ctrl + a
                            (lctl ins) @ctrl-ins    200 first-release ()     ;; ctrl + insert = layer-aware action
                            (lmet ins) @meta-ins    200 first-release ()     ;; meta + insert = layer-aware action  
                            (lsft ins) C-t          200 first-release ()     ;; shift + insert = ctrl + t
                            (lctl lsft ins) C-w     200 first-release ()     ;; ctrl + shift + insert = ctrl + w
                            (lctl del) C-z          200 first-release ()     ;; ctrl + delete = ctrl + z
                            (lctl lsft del) C-S-z   200 first-release ()     ;; ctrl + shift + delete = ctrl + shift + z
                            (lalt lmet) C-q         200 first-release ()     ;; alt + meta = ctrl + q
                        )

                        (deflayer base
                            caps a s d f g h j k l ; '
                            lsft z x c v b n m , . /
                            lalt lmet lctl ralt rmet rctl rsft
                            ins del
                        )

                        (deflayer ghostty  
                            caps a s d f g h j k l ; '
                            lsft z x c v b n m , . /
                            lalt lmet lctl ralt rmet rctl rsft
                            ins del
                        )
                    '';
                    
                    # Additional defcfg options
                    extraDefCfg = ''
                        process-unmapped-keys yes
                        danger-enable-cmd no
                        log-layer-changes yes
                        concurrent-tap-hold yes
                    '';
                };
            };
        };

        # Install kanata package
        environment.systemPackages = with pkgs; [
            kanata
        ];
    };
}
