set laststatus=2            "display status line
syntax on                   "syntax highlighting
set number                  "line numbers
set softtabstop=4           "4 spaces for tab
set expandtab
set shiftwidth=4
set ttimeoutlen=5

colorscheme github

"set leader to space
"let mapleader=" "

"nerdtree
noremap <C-n> :NERDTreeToggle<CR>

"tabs
noremap ü :tabnew<CR>

"MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1
nnoremap <C-m> :MBEToggle<CR>

noremap <C-ü> :enew

""" splits """
set splitbelow
set splitright

"cursor
if &term =~ "xterm\\|rxvt"
  " solid underscore
  let &t_SI .= "\<Esc>[4 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

"ale
let g:ale_linters = {'cpp': ['clang']}

"spell check
"set spell
set spelllang=en_us,de_de

"vim plug
call plug#begin('~/.vim/plugged')

Plug 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1

Plug 'maxmellon/vim-jsx-pretty'