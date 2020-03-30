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
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'ervandew/supertab'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'mhinz/vim-startify'
    Plug 'dense-analysis/ale'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'mhinz/vim-signify'
    Plug 'junegunn/fzf.vim'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

" -----------------------
"     CONFIGURATION
" -----------------------
" NVIM
set hidden
set relativenumber
set mouse=a
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright
set timeoutlen=500
set spelllang=en,de
colorscheme gruvbox
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
" DEOPLETE
let g:deoplete#enable_at_startup = 1
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

" -----------------------
"      KEYBINDINGS
" -----------------------
let mapleader=" "
" BUFFERS
nnoremap <Leader>bn       :bn<CR>
nnoremap <Leader>bN       :bp<CR>
nnoremap <Leader>bd       :bd<CR>
nnoremap <Leader>bb       :enew<CR>
" SPLITS
nnoremap <Leader>sl       :vs<CR>
nnoremap <Leader>sj       :sp<CR>
" NERDTREE
nnoremap <c-n>            :NERDTreeToggle<CR>
" TERMINAL
tnoremap <Esc>            <C-\><C-n>
nnoremap <Leader>t        :new<CR>:term<CR>
" WHICH-KEY
nnoremap <silent><leader> :WhichKey '<Space>'<CR>
" FZF
nnoremap <Leader>f        :Files<CR>