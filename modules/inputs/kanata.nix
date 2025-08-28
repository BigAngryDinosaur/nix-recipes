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

                            app-single-w (switch
                                () XX break
                            )
                            
                            app-double-w (switch
                                () XX break
                            )

                            app-single-e (switch
                                ((layer ghostty)) (macro C-s 50 s) break    ;; Search
                                () XX break
                            )

                            app-double-e (switch
                                ((layer ghostty)) (macro C-s 50 e) break    ;; Edit
                                () XX break
                            )

                            app-single-r (switch
                                ((layer ghostty)) (macro C-n) break         ;; Resize pane
                                () XX break
                            )

                            app-double-r (switch
                                ((layer ghostty)) (macro C-h) break         ;; Move pane
                                () XX break
                            )

                            app-single-t (switch
                                ((layer ghostty)) (macro C-t 50 n) break    ;; New tab
                                () XX break
                            )

                            app-double-t (switch
                                () XX break
                            )

                            app-single-a (switch
                                () XX break
                            )
                            
                            app-double-a (switch
                                () XX break
                            )

                            app-single-s (switch
                                () XX break
                            )
                            
                            app-double-s (switch
                                () XX break
                            )

                            app-single-d (switch
                                () XX break
                            )
                            
                            app-double-d (switch
                                () XX break
                            )

                            app-single-f (switch
                                ((layer ghostty)) (macro C-p 50 f) break    ;; Fullscreen pane
                                () XX break
                            )
                            
                            app-double-f (switch
                                () XX break
                            )

                            app-single-g (switch
                                ((layer ghostty)) (macro C-p 50 d) break    ;; New pane down
                                () XX break
                            )
                            
                            app-double-g (switch
                                ((layer ghostty)) (macro C-p 50 r) break    ;; New pane right
                                () XX break
                            )

                            app-single-z (switch
                                () XX break
                            )

                            app-double-z (switch
                                () XX break
                            )

                            app-single-x (switch
                                ((layer ghostty)) (macro C-p 50 x) break    ;; Close pane
                                () XX break
                            )

                            app-double-x (switch
                                () XX break
                            )

                            app-single-c (switch
                                () XX break
                            )

                            app-double-c (switch
                                () XX break
                            )

                            app-single-v (switch
                                () XX break
                            )

                            app-double-v (switch
                                () XX break
                            )

                            app-single-b (switch
                                ((layer ghostty)) M-S-f break               ;; 
                                () XX break
                            )

                            app-double-b (switch
                                () XX break
                            )

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
                            (lalt lmet ins) C-q     200 first-release ()     ;; alt + meta + insert = ctrl + q

                            ;; App specific

                            (lmet lalt lsft w) @app-single-w 200 first-release () ;; single w
                            (lctl lmet lsft w) @app-double-w 200 first-release () ;; double w

                            (lmet lalt lsft e) @app-single-e 200 first-release () ;; single e
                            (lctl lmet lsft e) @app-double-e 200 first-release () ;; double e

                            (lmet lalt lsft r) @app-single-r 200 first-release () ;; single r
                            (lctl lmet lsft r) @app-double-r 200 first-release () ;; double r

                            (lmet lalt lsft t) @app-single-t 200 first-release () ;; single t
                            (lctl lmet lsft t) @app-double-t 200 first-release () ;; double t


                            (lmet lalt lsft a) @app-single-a 200 first-release () ;; single a
                            (lctl lmet lsft a) @app-double-a 200 first-release () ;; double a

                            (lmet lalt lsft s) @app-single-s 200 first-release () ;; single s
                            (lctl lmet lsft s) @app-double-s 200 first-release () ;; double s

                            (lmet lalt lsft d) @app-single-d 200 first-release () ;; single d
                            (lctl lmet lsft d) @app-double-d 200 first-release () ;; double d

                            (lmet lalt lsft f) @app-single-f 200 first-release () ;; single f
                            (lctl lmet lsft f) @app-double-f 200 first-release () ;; double f

                            (lmet lalt lsft g) @app-single-g 200 first-release () ;; single g
                            (lctl lmet lsft g) @app-double-g 200 first-release () ;; double g


                            (lmet lalt lsft z) @app-single-z 200 first-release () ;; single z
                            (lctl lmet lsft z) @app-double-z 200 first-release () ;; double z

                            (lmet lalt lsft x) @app-single-x 200 first-release () ;; single x
                            (lctl lmet lsft x) @app-double-x 200 first-release () ;; double x

                            (lmet lalt lsft c) @app-single-c 200 first-release () ;; single c
                            (lctl lmet lsft c) @app-double-c 200 first-release () ;; double c

                            (lmet lalt lsft v) @app-single-v 200 first-release () ;; single v
                            (lctl lmet lsft v) @app-double-v 200 first-release () ;; double v

                            (lmet lalt lsft b) @app-single-b 200 first-release () ;; single b
                            (lctl lmet lsft b) @app-double-b 200 first-release () ;; double b
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
