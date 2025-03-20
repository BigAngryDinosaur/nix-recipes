{ pkgs, inputs, ... }: {
    fonts = {
        packages = with pkgs; [
            jetbrains-mono
            nerd-fonts.jetbrains-mono
            nerd-fonts.symbols-only
            font-awesome
            corefonts 
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-emoji
            nerd-fonts.fira-code
        ];

        # causes more issues than it solves
        enableDefaultPackages = false;

        fontDir = {
            enable = true;
            decompressFonts = true;
        };
    };
}
