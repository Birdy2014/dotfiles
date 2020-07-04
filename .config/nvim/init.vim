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
    Plug 'morhetz/gruvbox'
    Plug 'ervandew/supertab'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'mhinz/vim-startify'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'mhinz/vim-signify'
    Plug 'junegunn/fzf.vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'alvan/vim-closetag'
    Plug 'unblevable/quick-scope'
    Plug 'vimwiki/vimwiki'
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
call plug#end()

" -----------------------
"       FUNCTIONS
" -----------------------
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" -----------------------
"        AUTOCMDS
" -----------------------

" Remove trailing spaces
autocmd BufWritePre * %s/\s\+$//e

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
set termguicolors
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
" HEXOKINASE
let g:Hexokinase_highlighters = [ 'foregroundfull' ]

" -----------------------
"      KEYBINDINGS
" -----------------------
let mapleader=" "
" BUFFERS
nnoremap <Leader>d        :bd<CR>
nnoremap <Leader>D        :bd!<CR>
nnoremap <Leader>b        :enew<CR>
nnoremap <silent> <m-j>   :bn<CR>
nnoremap <silent> <m-k>   :bp<CR>
" TABS
nnoremap <silent> <m-h>   :tabprevious<CR>
nnoremap <silent> <m-l>   :tabnext<CR>
" SPLITS
nnoremap <Leader>sh       :vs<CR>
nnoremap <Leader>sj       :sp<CR>
nnoremap <Leader>sk       :sp<CR>
nnoremap <Leader>sl       :vs<CR>
nnoremap <silent> <c-h>   <c-w>h
nnoremap <silent> <c-j>   <c-w>j
nnoremap <silent> <c-k>   <c-w>k
nnoremap <silent> <c-l>   <c-w>l
" NERDTREE
nnoremap <silent> <c-n>   :NERDTreeToggle<CR>
" TERMINAL
tnoremap <Esc>            <C-\><C-n>
nnoremap <Leader>t        :new<CR>:term<CR>
" WHICH-KEY
nnoremap <silent><leader> :WhichKey '<Space>'<CR>
" FZF
nnoremap <Leader>f        :Files<CR>
" COC
nnoremap <silent> K :call <SID>show_documentation()<CR>
