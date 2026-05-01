-- GLOBAL OPTIONS

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false

-- OPTIONS

vim.o.number = true
vim.o.relativenumber = true

vim.o.statusline = "%< %f %h%w%m%r%=%-14.(%l/%L%) %-8.(%P%)"
vim.o.showmode = false
vim.o.modeline = false

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.mouse = "a"

vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.signcolumn = "yes"
vim.o.scrolloff = 10

vim.o.cursorline = true

vim.o.confirm = true
vim.o.swapfile = true
vim.o.undofile = true
vim.o.foldlevel = 99

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- KEYMAPS

-- Remap for netrw
vim.keymap.set("n", "\\", ":Ex<CR>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear search highlights when pressing <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- AUTOCOMMANDS

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- NEOVIDE
if vim.g.neovide then
    vim.o.guifont = "monospace:h12"
end

-- PLUGINS

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({

	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false,
		build = ":TSUpdate",

		-- HERE
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = { "c", "lua", "python", "javascript", "typescript", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
				ignore_install = {},
				modules = {},
				sync_install = false,
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
				  enable = true
				}
			}

			vim.wo.foldmethod = 'expr'
			vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		end
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				---@module 'mason.settings'
				---@type MasonSettings
				---@diagnostic disable-next-line: missing-fields
				opts = {},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)

					vim.keymap.set('n', 'grD', function()
						MiniExtra.pickers.lsp({ scope = 'declaration'})
					end, { buffer = buf, desc = '[G]oto [D]eclaration' })

					vim.keymap.set('n', 'grd', function()
						MiniExtra.pickers.lsp({ scope = 'definition'})
					end, { buffer = buf, desc = '[G]oto [D]efinition' })

					vim.keymap.set('n', 'grt', function()
						MiniExtra.pickers.lsp({ scope = 'type_definition'})
					end, { buffer = buf, desc = '[G]oto [T]ype Definition' })

					vim.keymap.set('n', 'grr', function()
						MiniExtra.pickers.lsp({ scope = 'references'})
					end, { buffer = buf, desc = '[G]oto [R]eferences' })

					vim.keymap.set('n', 'gri', function()
						MiniExtra.pickers.lsp({ scope = 'implementation'})
					end, { buffer = buf, desc = '[G]oto [I]mplementation' })

					vim.keymap.set('n', 'gO', function()
						MiniExtra.pickers.lsp({ scope = 'document_symbol'})
					end, { buffer = buf, desc = 'Document Symbols' })

					vim.keymap.set('n', 'gW', function()
						MiniExtra.pickers.lsp({ scope = 'workspace_symbol'})
					end, { buffer = buf, desc = 'Workspace Symbols' })

					vim.keymap.set('n', '<leader>d', function()
						MiniExtra.pickers.diagnostic()
					end, { buffer = buf, desc = 'Show [D]iagnostics' })

					vim.keymap.set('n', 		'grn', vim.lsp.buf.rename, 		{ buffer = buf, desc = '[R]e[n]ame' })
					vim.keymap.set({'n', 'x'}, 	'gra', vim.lsp.buf.code_action, { buffer = buf, desc = '[G]oto Code [A]ction' })

					vim.api.nvim_create_autocmd("CursorHold", {
						callback = function()
							local opts = {
								focusable = false,
								close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
								source = 'always',
								prefix = ' ',
								scope = 'line',
							}
							vim.diagnostic.open_float(nil, opts)
						end,
					})

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						vim.keymap.set('n', "<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, { buffer = buf, desc = "[T]oggle Inlay [H]ints" })
					end
				end,
			})

			-- HERE
			---@type table<string, vim.lsp.Config>
			local servers = {
				clangd = {},
				jedi_language_server = {},
				ts_ls = {},
				stylua = {},

				lua_ls = {
					on_init = function(client)
						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
								path = { "lua/?.lua", "lua/?/init.lua" },
							},
						})
					end,
					---@type lspconfig.settings.lua_ls
					settings = {
						Lua = {
							format = { enable = false }, -- Disable formatting 
							diagnostics = {
								globals = { "vim", "buf", "MiniExtra" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					},
				},
			}

			-- HERE
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Tools Mason should install
				"clangd",
				"jedi-language-server",
				"black",
				"typescript-language-server",
				"prettier",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		---@module 'conform'
		---@type conform.setupOpts
		opts = {
			notify_on_error = false,
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- HERE
			formatters_by_ft = {
				python = { "black" },
				c = { "clangd" },
				cpp = { "clangd" },
				lua = { "stylua" },
				javascript = { "prettier", stop_after_first = true },
			},
		},
	},

	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				-- All presets have the following mappings:
				-- <c-space>: 	Open menu/open docs if already open
				-- <c-n>/<c-p> 	Select next/previous item
				-- <c-e>: 		Hide menu
				-- <c-k>: 		Toggle signature help
				preset = "default",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				list = {
					selection = { preselect = false },
				},
			},

			sources = {
				default = { "lsp", "path", "snippets" },
			},

			fuzzy = { implementation = "lua" },

			-- Shows a help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.diff").setup()
			require("mini.pick").setup()
			require("mini.extra").setup()

			vim.keymap.set('n', '<leader>ff', ':Pick files<CR>',	 { silent = true })
			vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { silent = true })
			vim.keymap.set('n', '<leader>fb', ':Pick buffers<CR>', 	 { silent = true })
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require('onedark').setup {
				style = 'dark',
				colors = { red = '#abb2bf' },
				code_style = { comments = 'none' },
			}
			require('onedark').load()
		end
	},

})

