-- GLOBAL OPTIONS

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- OPTIONS

vim.o.number = true
vim.o.relativenumber = true

vim.o.statusline = '%<%f %h%w%m%r%=%-14.(%l/%L%) %-8.(%P%)'
vim.o.showmode = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.mouse = "a"

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

vim.o.list = false
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

vim.o.signcolumn = 'yes'
vim.o.scrolloff = 10

vim.o.confirm = true
vim.o.swapfile = true

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
		vim.highlight.on_yank()
	end,
})

-- PLUGINS

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('navarasu/onedark.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-mini/mini.pick')
Plug('nvim-mini/mini.diff')
Plug('nvim-mini/mini.pairs')
Plug('sheerun/vim-polyglot')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
vim.call('plug#end')

require('onedark').setup({
	code_style = {
		comments = 'none',
		keywords = 'none',
		functions = 'none',
		strings = 'none',
		variables = 'none'
	},
})

require('nvim-web-devicons').setup()

require("nvim-tree").setup({
	view = {
		width = 35,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

require('mini.pick').setup()
require('mini.diff').setup()
require('mini.pairs').setup()
require("ibl").setup()

vim.cmd('colorscheme onedark')

-- NVIM-TREE OPTIONS

vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>", { silent = true })

-- MINI.PICK OPTIONS

vim.keymap.set("n", "<leader>sf", ":Pick files<CR>", { silent = true })
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<CR>", { silent = true })
vim.keymap.set("n", "<leader>sb", ":Pick buffers<CR>", { silent = true })

-- COC OPTIONS

local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

-- Make <CR> accept selected completion item and notify coc.nvim to autoindent
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use [g and ]g to navigate diagnostics
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- Code navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end

vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- Highlight the symbol and its references on a CursorHold event (cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Format current buffer
vim.keymap.set("n", "<space>f", ":call CocAction('format')<cr>")

-- Mappings for CoCList
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Show all diagnostics
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
