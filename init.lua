-- GLOBAL OPTIONS

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- OPTIONS

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.mouse = "a"
vim.o.showmode = false

vim.schedule(
	function()
		vim.o.clipboard = "unnamedplus"
	end
)

vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 10

vim.o.confirm = true

-- KEYMAPS

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear search highlights when pressing <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- AUTOCOMMANDS

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- PLUGINS

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('projekt0n/github-nvim-theme')
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-mini/mini.pick')
Plug('nvim-mini/mini.diff')
Plug('nvim-mini/mini.pairs')
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
vim.call('plug#end')

vim.cmd('silent! colorscheme github_dark')

require('github-theme').setup()
require('lualine').setup({
	options = { theme = 'nord' }
})
require('nvim-web-devicons').setup()
require('mini.pick').setup()
require('mini.diff').setup()
require('mini.pairs').setup()
