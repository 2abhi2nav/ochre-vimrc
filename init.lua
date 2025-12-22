
-- Options

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.statusline = "%t%m  %l/%L:%c"

-- Setup

vim.g.mapleader = " "
local map = vim.keymap.set

-- Plugins

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
Plug('sheerun/vim-polyglot')
Plug('joshdick/onedark.vim')
vim.call('plug#end')

vim.cmd("colorscheme onedark")

-- CoC options

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

map("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

map("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
map("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

map("n", "gd", "<Plug>(coc-definition)", {silent = true})
map("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
map("n", "gi", "<Plug>(coc-implementation)", {silent = true})
map("n", "gr", "<Plug>(coc-references)", {silent = true})

function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
map("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

map("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

map("n", "<leader>f", ":call CocAction('format')<CR>", {})
map("n", "<leader>or", ":call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>", {})

map("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
map("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
map("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
