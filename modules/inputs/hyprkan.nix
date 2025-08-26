{ config, pkgs, lib, userSettings, ... }:
let
    inherit (lib) mkEnableOption mkIf mkOption types;
    
    hyprkan = pkgs.stdenv.mkDerivation rec {
        pname = "hyprkan";
        version = "0.1.0";
        
        src = pkgs.fetchFromGitHub {
            owner = "mdSlash";
            repo = "hyprkan";
            rev = "ed72fb7817f4e99ad71f3780b5f8ae7f50300407";
            hash = "sha256-4J0yQSkFTbHTDFBXECbCs/43xTDbeB/f3J7tZIbjbwM=";
        };
        
        nativeBuildInputs = [ pkgs.makeWrapper ];
        
        pythonPath = with pkgs.python3Packages; [
            (i3ipc.overridePythonAttrs { doCheck = false; })
            xlib
        ];
        
        installPhase = ''
            runHook preInstall
            
            mkdir -p $out/bin
            cp src/hyprkan.py $out/bin/hyprkan
            chmod +x $out/bin/hyprkan
            
            wrapProgram $out/bin/hyprkan \
                --prefix PYTHONPATH : "${pkgs.python3.pkgs.makePythonPath pythonPath}" \
                --prefix PATH : "${pkgs.python3}/bin" \
                --set PYTHONDONTWRITEBYTECODE 1
            
            runHook postInstall
        '';
        
        meta = with lib; {
            description = "App-aware Kanata layer switcher for Linux";
            homepage = "https://github.com/mdSlash/hyprkan";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.linux;
        };
    };
    
    # Default hyprkan configuration
    defaultConfig = pkgs.writeText "hyprkan-config.json" (builtins.toJSON [
        {
            class = "firefox|chromium|chrome";
            title = "*";
            layer = "base";
        }
        {
            class = "com.mitchellh.ghostty";
            title = "*";
            layer = "ghostty";
        }
        {
            class = "*";
            title = "*";
            layer = "base";
        }
    ]);
in
{
    options = {
        hyprkan.enable = mkEnableOption "Enable hyprkan app-aware layer switching";
        hyprkan.configFile = mkOption {
            type = types.path;
            default = defaultConfig;
            description = "Path to hyprkan configuration file";
        };
        hyprkan.kanataPort = mkOption {
            type = types.port;
            default = 10000;
            description = "Port where kanata TCP server is running";
        };
    };

    config = mkIf config.hyprkan.enable {
        # Ensure kanata is enabled and configured for TCP
        kanata.enable = lib.mkDefault true;
        
        # Install hyprkan package
        environment.systemPackages = [ hyprkan ];

        # Set up hyprkan user service
        home-manager.users.${userSettings.username} = {
            systemd.user.services.hyprkan = {
                Unit = {
                    Description = "Hyprkan app-aware Kanata layer switcher";
                    PartOf = [ "graphical-session.target" ];
                    After = [ "graphical-session.target" "kanata@main.service" ];
                    Wants = [ "kanata@main.service" ];
                };
                
                Install = {
                    WantedBy = [ "graphical-session.target" ];
                };
                
                Service = {
                    Type = "simple";
                    Restart = "on-failure";
                    RestartSec = "5s";
                    ExecStart = "${hyprkan}/bin/hyprkan -c ${config.hyprkan.configFile} -p ${toString config.hyprkan.kanataPort}";
                    Environment = [
                        "WAYLAND_DISPLAY=wayland-1"
                        "XDG_SESSION_TYPE=wayland"
                    ];
                };
            };
        };
    };
}
