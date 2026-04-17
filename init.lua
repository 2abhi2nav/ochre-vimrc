
-- GLOBAL OPTIONS

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

vim.g.ale_completion_enabled = 1
vim.g.ale_lint_on_text_changed = 'always'

vim.g.ale_linters = {
    python = { 'jedils' },
}

vim.g.ale_fixers = {
    javascript = { 'prettier', 'eslint' },
    python = { 'black' },
	c = { 'clangd' },
	cpp = { 'clangd' },
	lua = { 'lua-format' },
}


-- OPTIONS

vim.o.number = true
vim.o.relativenumber = true

vim.o.statusline = '%< %f %h%w%m%r%=%-14.(%l/%L%) %-8.(%P%)'
vim.o.showmode = false
vim.o.modeline = false

vim.o.winborder = 'single'
vim.o.pumborder = 'single'

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
	desc = 'Highlight when yanking text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})


-- PLUGINS

vim.pack.add({
	'https://github.com/nvim-mini/mini.comment',
	'https://github.com/nvim-mini/mini.pairs',
	'https://github.com/nvim-mini/mini.diff',
	'https://github.com/nvim-mini/mini.pick',

	'https://github.com/nvim-lualine/lualine.nvim',
	'https://github.com/lukas-reineke/indent-blankline.nvim',

	'https://github.com/sheerun/vim-polyglot',
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/dense-analysis/ale',
})

require('mini.comment').setup()
require('mini.pairs').setup()
require('mini.diff').setup()
require('mini.pick').setup()

require('lualine').setup()
require('ibl').setup()

require('mason').setup()

vim.cmd('colorscheme catppuccin')


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

