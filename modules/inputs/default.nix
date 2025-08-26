{ config, ... }: {
    imports = [
        ./kanata.nix
        ./hyprkan.nix
    ];

    config = {
        kanata.enable = true;
        hyprkan.enable = true; 
    };
}
