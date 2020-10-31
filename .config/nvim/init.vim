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
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'alvan/vim-closetag'
    Plug 'unblevable/quick-scope'
    Plug 'vimwiki/vimwiki'
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'tpope/vim-fugitive'
    Plug 'Yggdroot/indentLine'
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

function! s:bclose(bang)
    let btarget = bufnr('%')
    if empty(a:bang) && getbufvar(btarget, '&modified')
        echohl ErrorMsg
        echomsg 'No write since last change'
        echohl NONE
        return
    endif
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    for wnr in wnums
        let bcount = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
        execute wnr.'wincmd w'
        if bcount < 2
            execute 'enew'
        else
            execute 'bnext'
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
endfunction
command! -bang -register Bclose call s:bclose(<q-bang>)

" -----------------------
"        AUTOCMDS
" -----------------------

" Remove trailing spaces
autocmd BufWritePre * %s/\s\+$//e

" Enter insert mode when navigating to a terminal
autocmd BufWinEnter,WinEnter term://* startinsert

if $TERM == "st-256color"
    " Set transparent background after plugins are loaded
    autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
endif

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
set guifont=Mononoki\ Nerd\ Font:14
colorscheme gruvbox
" NERDTREE
let g:NERDTreeWinPos = "right"
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
nmap Y y$
" BUFFERS
nnoremap <silent> <c-q>        :q<CR>
nnoremap <silent> <leader>d    :Bclose<CR>
nnoremap <silent> <leader>D    :Bclose!<CR>
nnoremap <silent> <leader>b    :enew<CR>
nnoremap <silent> <m-j>        :bn<CR>
nnoremap <silent> <m-k>        :bp<CR>
" TABS
nnoremap <silent> <m-h>        :tabprevious<CR>
nnoremap <silent> <m-l>        :tabnext<CR>
" SPLITS
nnoremap <silent> <leader>sh   :vs<CR>
nnoremap <silent> <leader>sj   :sp<CR>
nnoremap <silent> <leader>sk   :sp<CR>
nnoremap <silent> <leader>sl   :vs<CR>
" NERDTREE
nnoremap <silent> <c-n>        :NERDTreeToggle<CR>
" TERMINAL
tnoremap <silent> <C-h>        <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <silent> <C-j>        <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <silent> <C-k>        <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <silent> <C-l>        <C-\><C-n>:TmuxNavigateRight<CR>
tnoremap <silent> <c-q>        <C-\><C-n>:bd!<CR>
nnoremap <silent> <leader>t    :sp<CR>:resize 10<CR>:term<CR>:set nobuflisted<CR>i
" WHICH-KEY
nnoremap <silent> <leader>     :WhichKey '<Space>'<CR>
" FZF
nnoremap <silent> <leader>f    :Files<CR>
" COC
nnoremap <silent> K            :call <SID>show_documentation()<CR>

