{
    enable = true;
    onAttach = ''
      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.start(bufnr, client.id)
      end
    '';
    servers = {
        cssls.enable = true;
        html.enable = true;
        pyright.enable = true;
        ts_ls.enable = true;
        asm_lsp.enable = true;
        nixd.enable = true;
        nushell.enable = true;
        hls = {
            enable = true;
            installGhc = false;
            package = null;
        };
    };
}
