{ pkgs, ... }:
{
    # UI plugins
    lualine = import ./plugins/ui/lualine.nix;
    barbar = import ./plugins/ui/barbar.nix;
    web-devicons = import ./plugins/ui/web-devicons.nix;

    # Git plugins
    gitgutter = import ./plugins/git/gitgutter.nix;

    # Editor plugins
    mini = import ./plugins/editor/mini.nix;
    indent-blankline = import ./plugins/editor/indent-blankline.nix;
    flash = import ./plugins/editor/flash.nix;
    telescope = import ./plugins/editor/telescope.nix;
    nvim-autopairs = import ./plugins/editor/nvim-autopairs.nix;
    neorg = import ./plugins/editor/neorg.nix;

    # File management plugins
    neo-tree = import ./plugins/file-management/neo-tree.nix;

    # Syntax plugins
    treesitter = import ./plugins/syntax/treesitter.nix { inherit pkgs; };
    treesitter-refactor = import ./plugins/syntax/treesitter-refactor.nix;

    # LSP plugins
    lsp = import ./plugins/lsp/lsp.nix;
    lsp-format = import ./plugins/lsp/lsp-format.nix;
    none-ls = import ./plugins/lsp/none-ls.nix;
    lspkind = import ./plugins/lsp/lspkind.nix;
    lsp-lines = import ./plugins/lsp/lsp-lines.nix;
    cmp = import ./plugins/lsp/cmp.nix;

    # Snippets plugins
    luasnip = import ./plugins/snippets/luasnip.nix;
}