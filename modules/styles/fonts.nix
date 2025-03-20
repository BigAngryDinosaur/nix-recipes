{ pkgs, inputs, ... }: {
    fonts = {
        packages = with pkgs; [
            noto-fonts
            noto-fonts-emoji
            jetbrains-mono
            nerd-fonts.jetbrains-mono
            nerd-fonts.symbols-only
        ];

        # causes more issues than it solves
        enableDefaultPackages = false;

        fontDir = {
            enable = true;
            decompressFonts = true;
        };
    };
}
