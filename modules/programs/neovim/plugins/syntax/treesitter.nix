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
        html
        javascript
        json
        lua
        markdown
        nix
        python
        rust
        toml
        typescript
        vim
        vimdoc
        yaml
    ];
    settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
        indent.enable = true;
    };
}