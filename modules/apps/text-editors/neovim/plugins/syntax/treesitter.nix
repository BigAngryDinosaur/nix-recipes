{ pkgs, ... }:
{
    enable = true;
    nixvimInjections = true;
    folding = false;
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
    };
}
