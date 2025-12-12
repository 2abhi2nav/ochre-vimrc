" Main

filetype plugin indent on
syntax on

set nocompatible
set autoindent
set laststatus=2
set noshowmode
set number relativenumber
set mouse=a

set backspace=indent,eol,start
set shiftwidth=4
set tabstop=4

" Keymaps

inoremap kj <Esc>
vnoremap kj <Esc>
nnoremap <leader>f gg=G''
inoremap <expr> <cr> getline(".")[col(".")-2:col(".")-1]=="{}" ? "<cr><esc>O" : "<cr>"

" Plugins

call plug#begin()
Plug 'sainnhe/gruvbox-material'
Plug 'itchyny/lightline.vim'
Plug 'Townk/vim-autoclose'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
call plug#end()

" Colorscheme and GUI

set termguicolors
set background=dark

colorscheme gruvbox-material
let g:lightline = { 'colorscheme': 'gruvbox_material', }

" Coc Options

set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

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

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

nmap <leader>cl  <Plug>(coc-codelens-action)

