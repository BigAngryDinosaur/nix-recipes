{
    enable = true;
    enableLspFormat = true;
    sources = {
        formatting = {
            prettier = {
                enable = true;
                disableTsServerFormatter = true;
            };
            markdownlint.enable = true;
        };
    };
}