{ config, lib, inputs, pkgs, vars, ... } :

{
	home-manager.users.${vars.user.name} = {

		imports = [ inputs.nixvim.homeManagerModules.nixvim ];

		programs.nixvim = {
			enable = true;

			viAlias = true;
			vimAlias = true;

			opts = {
				number = true;
				relativenumber = true;
				hidden = true;
				foldlevel = 99;
				shiftwidth = 4;
				tabstop = 4;
				softtabstop = 4;
				expandtab = true;
				autoindent = true;
				wrap = false;
				scrolloff = 5;
				sidescroll = 40;
				fileencoding = "utf-8";
				swapfile = false;
				conceallevel = 3;
				cursorline = true;
			};

			globals = {
				mapleader = " ";
				maplocalleader = " ";
			};

			keymaps = [
			{
				key = "<leader>w";
				action = "<CMD>w<CR>";
				options.desc = "Save";
			}
			{
				key = "<leader>q";
				action = "<CMD>q<CR>";
				options.desc = "Quit";
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
			];

			plugins = {
				lualine.enable = true;
				barbar.enable = true;
                web-devicons.enable = true;
				gitgutter = {
					enable = true;
					settings = {
						map_keys = false;
					};
				};
				mini = {
					enable = true;
					modules = {
						# Editing
						ai = { };
						align = { };
						move = { };
						surround = { };
						comment = { };

						# General

						# Appearance
						indentscope = {};


					};
				};

				indent-blankline = {
					enable = true;
					settings.scope.enabled = false;
				};

				flash = {
					enable = true;
				};

				telescope = {
					enable = true;
					settings = {
						pickers.find_files = {
							hidden = true;
						};
					};
					keymaps = {
						"<leader>ff" = {
							action = "find_files";
							options = {
								desc = "Find File";
							};
						};
						"<leader>fg" = {
							action = "live_grep";
							options = {
								desc = "Find Via Grep";
							};
						};
						"<leader>fb" = {
							action = "buffers";
							options = {
								desc = "Find Buffers";
							};
						};
						"<leader>fh" = {
							action = "help_tags";
							options = {
								desc = "Find Help";
							};
						};
					};
				};

				nvim-autopairs.enable = true;

				neo-tree = {
					enable = true;
					window.width = 30;
					closeIfLastWindow = true;
					extraOptions = {
						filesystem = {
							filtered_items = {
								visible = true;
							};
						};
					};
				};

				treesitter = {
					enable = true;
					nixvimInjections = true;
					folding = false;
					nixGrammars = true;
					grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
					settings = {
						ensure_installed = "all";
						highlight.enable = true;
						incremental_selection.enable = true;
						indent.enable = true;
					};
				};
				treesitter-refactor = {
					enable = true;
				};

				lsp = {
					enable = true;
					servers = {
						cssls.enable = true;
						html.enable = true;
						pyright.enable = true;
						ts_ls.enable = true;
					};
				};

				lsp-format.enable = true;

				none-ls = {
					enable = true;
					enableLspFormat = true;
					sources = {
						formatting = {
							prettier = {
								enable = true;
								disableTsServerFormatter = true;
							};
							nixpkgs_fmt.enable = true;
							markdownlint.enable = true;
						};
					};
				};

				lspkind = {
					enable = true;
					cmp = {
						enable = true;
						menu = {
							nvim_lsp = "[LSP]";
							nvim_lua = "[api]";
							path = "[path]";
							luasnip = "[snip]";
							look = "[look]";
							buffer = "[buffer]";
							orgmode = "[orgmode]";
							neorg = "[neorg]";
						};
					};
				};

				lsp-lines.enable = true;
			};
		};
	};
}
