
-- GLOBAL OPTIONS

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

vim.g.ale_completion_enabled = 1
vim.g.ale_lint_on_text_changed = 'always'
vim.g.ale_floating_preview = 1
vim.g.ale_cursor_detail = 1

vim.g.ale_linters = {
	javascript = { 'tsserver' },
	typescript = { 'tsserver' },
    python = { 'jedils' },
	c = { 'clangd' },
	cpp = { 'clangd' },
	lua = { 'lua_language_server' },
}

vim.g.ale_fixers = {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    python = { 'black' },
	c = { 'clangd' },
	cpp = { 'clangd' },
	lua = { 'stylua' },
}

vim.g.ale_disable_lsp = 0
vim.g.ale_javascript_tsserver_executable = 'typescript-language-server'
vim.g.ale_typescript_tsserver_executable = 'typescript-language-server'
vim.g.ale_typescript_tsserver_project_root = 'ALE_LuaRootWrapper'
vim.g.ale_typescript_tsserver_use_global = 0
vim.g.ale_typescript_tsserver_config = { stdio = true }

vim.cmd([[
  function! ALE_UniversalRoot(buffer) abort
    " Define the markers we want to look for
    let l:markers = ['.git', 'tsconfig.json', 'package.json', 'pyproject.toml', '.clangd', 'Makefile']
    
    " Loop through markers and find the first one that exists
    for l:marker in l:markers
      let l:found = ale#path#FindNearestFile(a:buffer, l:marker)
      if !empty(l:found)
        return fnamemodify(l:found, ':h')
      endif
    endfor

    " ABSOLUTE FALLBACK: If no markers found, use the current file's directory
    return expand('#' . a:buffer . ':p:h')
  endfunction
]])

-- Apply the fixed function globally
vim.g.ale_lsp_root = 'ALE_UniversalRoot'


-- OPTIONS

vim.o.number = true
vim.o.relativenumber = true

vim.o.statusline = '%< %f %h%w%m%r%=%-14.(%l/%L%) %-8.(%P%)'
vim.o.showmode = false
vim.o.modeline = false
vim.o.cursorline = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.mouse = 'a'

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

vim.o.signcolumn = 'yes'
vim.o.scrolloff = 10

vim.o.confirm = true
vim.o.swapfile = true
vim.o.undofile = true

vim.o.completeopt = "menuone,noselect,noinsert"

vim.schedule(
	function()
		vim.o.clipboard = 'unnamedplus'
	end
)


-- KEYMAPS

-- Remap for netrw
vim.keymap.set('n', '\\', ':Ex<CR>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear search highlights when pressing <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


-- AUTOCOMMANDS

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})


-- PLUGINS

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
	Plug('nvim-mini/mini.nvim')

	Plug('nvim-lualine/lualine.nvim')
	Plug('lukas-reineke/indent-blankline.nvim')
	Plug('navarasu/onedark.nvim')

	Plug('sheerun/vim-polyglot')
	Plug('mason-org/mason.nvim')
	Plug('dense-analysis/ale')
vim.call('plug#end')

require('mini.comment').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.diff').setup()
require('mini.pick').setup()

require('lualine').setup({
	options = {
		icons_enabled = true,
		theme = 'onedark',
		component_separators = { left = '|', right = '|'},
		section_separators = { left = '', right = ''},
	},
	 sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
})
require('ibl').setup()
require('onedark').setup({
	style = 'dark',
	colors = { red = '#abb2bf' },
	code_style = { comments = 'none' },
})
require('onedark').load()

require('mason').setup()

-- MINI.PICK OPTIONS

vim.keymap.set('n', '<leader>ff', ':Pick files<CR>',	 { silent = true })
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { silent = true })
vim.keymap.set('n', '<leader>fb', ':Pick buffers<CR>', 	 { silent = true })


-- ALE OPTIONS

vim.keymap.set('n', '<leader>f', '<Plug>(ale_fix)', { silent = true, remap = true })

vim.keymap.set('n', 'gd', 	'<Plug>(ale_go_to_definition)',  { silent = true, remap = true })
vim.keymap.set('n', 'gD', 	'<Plug>(ale_go_to_declaration)', { silent = true, remap = true })
vim.keymap.set('n', 'grr', 	'<Plug>(ale_find_references)',	 { silent = true, remap = true })
vim.keymap.set('n', 'gO', 	'<Plug>(ale_symbol_search)',	 { silent = true, remap = true })

vim.keymap.set('n', 'grn', 	'<Plug>(ale_rename)', 			{ silent = true, remap = true })
vim.keymap.set('n', 'gra', 	'<Plug>(ale_code_action)', 		{ silent = true, remap = true })
vim.keymap.set('n', 'goi', 	'<Plug>(ale_organize_imports)', { silent = true, remap = true })
vim.keymap.set('n', 'K', 	'<Plug>(ale_hover)', 			{ silent = true, remap = true })

vim.keymap.set('n', '[g', '<Plug>(ale_previous_wrap)', 	{ silent = true, remap = true })
vim.keymap.set('n', ']g', '<Plug>(ale_next_wrap)', 		{ silent = true, remap = true })

