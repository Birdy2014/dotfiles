" -----------------------
"        PLUGINS
" -----------------------
if ! filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data') . '/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'morhetz/gruvbox'
    Plug 'ervandew/supertab'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'mhinz/vim-startify'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'mhinz/vim-signify'
    Plug 'junegunn/fzf.vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'alvan/vim-closetag'
    Plug 'unblevable/quick-scope'
call plug#end()

" -----------------------
"     CONFIGURATION
" -----------------------
" NVIM
set hidden
set number relativenumber
set mouse=a
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright
set timeoutlen=500
set spelllang=en,de
set noshowmode
colorscheme gruvbox
" NERDTREE
let g:NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
" AIRLINE
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" FZF
let g:fzf_preview_window = 'right:60%'
" SUPERTAB
let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'
" QUICKSCOPE
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" -----------------------
"      KEYBINDINGS
" -----------------------
let mapleader=" "
" BUFFERS
nnoremap <Leader>bn       :bn<CR>
nnoremap <Leader>bN       :bp<CR>
nnoremap <Leader>bd       :bd<CR>
nnoremap <Leader>bb       :enew<CR>
nnoremap <c-n>            :bn<CR>
" SPLITS
nnoremap <Leader>sl       :vs<CR>
nnoremap <Leader>sj       :sp<CR>
" NERDTREE
nnoremap <Leader>n        :NERDTreeToggle<CR>
" TERMINAL
tnoremap <Esc>            <C-\><C-n>
nnoremap <Leader>t        :new<CR>:term<CR>
" WHICH-KEY
nnoremap <silent><leader> :WhichKey '<Space>'<CR>
" FZF
nnoremap <Leader>f        :Files<CR>
