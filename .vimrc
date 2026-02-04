" Main

filetype plugin indent on
syntax on
set nocompatible
set clipboard=unnamedplus

set laststatus=2
set noshowmode
set number relativenumber
set mouse=a

set hlsearch
set incsearch
set ignorecase
set smartcase

set wrap
set linebreak
set nolist
set textwidth=0

set autoindent
set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4

" Non-Plugin Keymaps

let mapleader=" "

nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

tnoremap <Esc> <C-\><C-n>

" Plugins

call plug#begin()
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
call plug#end()

" Colorscheme and GUI

set background=dark
set termguicolors

colorscheme tokyonight
let g:lightline = {'colorscheme' : 'tokyonight'}

" CoC Options

set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
highlight SignColumn guibg=NONE ctermbg=NONE

nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent :call CocActionAsync('highlight')

nmap <leader>f :call CocAction('format')<CR>

nmap <leader>rn <Plug>(coc-rename)

nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

nmap <leader>cl  <Plug>(coc-codelens-action)


" NerdTree Options

nnoremap <leader>e :NERDTreeToggle<CR>

" Indent Guide Options

let g:indent_guides_enable_on_vim_startup = 1

