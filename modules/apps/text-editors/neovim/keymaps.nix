[
    {
        key = "<leader>w";
        action = "<CMD>w<CR>";
        options.desc = "Save";
    }
    {
        key = "<leader>q";
        action = "<CMD>confirm q<CR>";
        options.desc = "Quit window";
    }
    {
        key = "<leader>Q";
        action = "<CMD>q!<CR>";
        options.desc = "Force Quit";
    }
    {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
    }
    {
        key = "<leader>sh";
        action = "<C-w>s";
        options.desc = "Split Horizontal";
    }
    {
        key = "<leader>sv";
        action = "<C-w>v";
        options.desc = "Split Vertical";
    }
    {
        key = "<leader>h";
        action = "<C-w>h";
        options.desc = "Select Window Left";
    }
    {
        key = "<leader>l";
        action = "<C-w>l";
        options.desc = "Select Window Right";
    }
    {
        key = "<leader>j";
        action = "<C-w>j";
        options.desc = "Select Window Below";
    }
    {
        key = "<leader>k";
        action = "<C-w>k";
        options.desc = "Select Window Above";
    }
    {
        key = "<leader>bb";
        action = "<CMD>BufferPick<CR>";
        options.desc = "Select Buffer";
    }
    {
        key = "<leader>bc";
        action = "<CMD>BufferClose<CR>";
        options.desc = "Close Current Buffer";
    }
    {
        key = "<leader>bn";
        action = "<CMD>:bnext<CR>";
        options.desc = "Next Buffer";
    }
    {
        key = "<leader>bp";
        action = "<CMD>:bprev<CR>";
        options.desc = "Previous Buffer";
    }
    {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Tab Text Right";
    }
    {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Tab Text Left";
    }
    {
        mode = "n";
        key = "gd";
        action = "<CMD>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Show lsp definition in floating window";
    }
    {
        mode = "n";
        key = "gD";
        action = "<CMD>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Load lsp definition in new buffer";
    }
    {
        mode = "n";
        key = "ge";
        action = "<CMD>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show lsp diagnostic in floating window";
    }
    {
        mode = "n";
        key = "<leader>r";
        action = ":! ";
        options.desc = "Run command";
    }
    {
        mode = "n";
        key = "<TAB>";
        action = "z=";
        options.desc = "Get spell suggestion";
    }
    {
        mode = "n";
        key = "\\\\";
        action = "<CMD>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
    }
    {
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
    }
    {
        key = "s";
        mode = [ "n" "x" "o" ];
        action = "function() require('flash').jump() end";
        lua = true;
        options = { desc = "Flash"; };
    }
    {
        key = "S";
        mode = [ "n" "x" "o" ];
        action = "function() require('flash').treesitter() end";
        lua = true;
        options = { desc = "Flash Treesitter"; };
    }
    {
        key = "r";
        mode = "o";
        action = "function() require('flash').remote() end";
        lua = true;
        options = { desc = "Remote Flash"; };
    }
    {
        key = "R";
        mode = [ "o" "x" ];
        action = "function() require('flash').treesitter_search() end";
        lua = true;
        options = { desc = "Treesitter Search"; };
    }
    {
        key = "<c-s>";
        mode = "c";
        action = "function() require('flash').toggle() end";
        lua = true;
        options = { desc = "Toggle Flash Search"; };
    }

    # UX Toggles
    {
        key = "<leader>uh";
        action = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
        lua = true;
        options.desc = "Toggle inlay hints";
    }
    {
        key = "<leader>uH";
        action = "function() vim.lsp.codelens.refresh() end";
        lua = true;
        options.desc = "Toggle codelens";
    }
    {
        key = "<leader>uc";
        action = "function() vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0 end";
        lua = true;
        options.desc = "Toggle conceal";
    }
    {
        key = "<leader>uv";
        action = "function() vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text }) end";
        lua = true;
        options.desc = "Toggle diagnostics virtual text";
    }
    {
        key = "<leader>uV";
        action = "function() vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines }) end";
        lua = true;
        options.desc = "Toggle diagnostics virtual lines";
    }

    # LSP Commands
    {
        key = "<leader>li";
        action = "<CMD>LspInfo<CR>";
        options.desc = "LSP info";
    }
    {
        key = "<leader>lf";
        action = "function() vim.lsp.buf.format() end";
        lua = true;
        options.desc = "Format document";
    }
    {
        key = "<leader>lS";
        action = "function() vim.lsp.buf.workspace_symbol() end";
        lua = true;
        options.desc = "Symbols outline";
    }
    {
        key = "<leader>ls";
        action = "function() vim.lsp.buf.document_symbol() end";
        lua = true;
        options.desc = "Document symbols";
    }
    {
        key = "<leader>ld";
        action = "function() vim.diagnostic.open_float() end";
        lua = true;
        options.desc = "Line diagnostics";
    }
    {
        key = "<leader>lD";
        action = "function() vim.diagnostic.setloclist() end";
        lua = true;
        options.desc = "All diagnostics";
    }
    {
        key = "<leader>la";
        action = "function() vim.lsp.buf.code_action() end";
        lua = true;
        options.desc = "Code actions";
    }
    {
        key = "<leader>lA";
        action = "function() vim.lsp.buf.code_action({ context = { only = { 'source' } } }) end";
        lua = true;
        options.desc = "Source code actions";
    }
    {
        key = "<leader>lh";
        action = "function() vim.lsp.buf.signature_help() end";
        lua = true;
        options.desc = "Signature help";
    }
]
