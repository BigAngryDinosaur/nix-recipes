{ pkgs, ... }:
{
    enable = true;
    nixvimInjections = true;
    folding.enable = false;
    nixGrammars = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        asm
        bash
        c
        cpp
        css
        dockerfile
        go
        haskell
        html
        javascript
        json
        lua
        markdown
        nim
        nim_format_string
        nix
        nu
        python
        rust
        toml
        typescript
        vim
        vimdoc
        yaml
    ] ++ (with pkgs.tree-sitter-grammars; [
        tree-sitter-norg
        tree-sitter-norg-meta
    ]);
    settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
        indent.enable = true;
        refactor = {
            highlight_definitions.enable = true;
            highlight_current_scope.enable = false;
            smart_rename.enable = true;
            navigation = {
                enable = true;
                keymaps = {
                    goto_definition = "gnd";
                    list_definitions = "gnD";
                    list_definitions_toc = "gO";
                    goto_next_usage = "<a-*>";
                    goto_previous_usage = "<a-#>";
                };
            };
        };
    };
}
