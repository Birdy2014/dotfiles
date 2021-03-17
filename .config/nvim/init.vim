" -----------------------
"        PLUGINS
" -----------------------
if ! filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data') . '/plugged')
    " Theme / Statusbars / Visual
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'morhetz/gruvbox'
    Plug 'machakann/vim-highlightedyank'
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
    Plug 'hoob3rt/lualine.nvim'
    Plug 'romgrk/barbar.nvim'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'junegunn/vim-peekaboo'

    " Navigation
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'justinmk/vim-sneak'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'michaeljsmith/vim-indent-object'

    " Coding
    Plug 'sheerun/vim-polyglot'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/completion-nvim'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'sbdchd/neoformat'

    " Other
    Plug 'vimwiki/vimwiki'
    Plug 'airblade/vim-rooter'
    Plug 'simnalamburt/vim-mundo'
call plug#end()

" -----------------------
"       FUNCTIONS
" -----------------------
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        lua vim.lsp.buf.hover()
    endif
endfunction

function! s:save_session()
    " Only save the session inside of a project
    if isdirectory('.git')
        " Close nvim-tree.lua
        NvimTreeClose
        " Close toggleterm
        if bufexists('toggleterm')
            bw! toggleterm
        endif
        " Save session
        mksession!
    endif
endfunction

function! s:load_session()
    if filereadable('Session.vim')
        source Session.vim
        NvimTreeOpen
    endif
endfunction

function! s:clang_format()
    if filereadable('.clang-format') && executable('clang-format')
        Neoformat clangformat
    endif
endfunction

" -----------------------
"        AUTOCMDS
" -----------------------

" Remove trailing spaces
autocmd BufWritePre * %s/\s\+$//e

" Enter insert mode when navigating to a terminal
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufWinEnter,WinEnter toggleterm startinsert

" Autocompletion
autocmd BufEnter * lua require'completion'.on_attach()

" Set cursorline for nvim-tree.lua
autocmd FileType NvimTree setlocal cursorline

" enable spell checking in vimwiki
autocmd BufReadPost,BufNewFile *.wiki setlocal spell

" Override python tabstop ftplugin (workaround so Treesitter doesn't break the indentation)
autocmd BufEnter *.py setlocal tabstop=4

" Session management
augroup manage_session
    autocmd!
    autocmd VimEnter * nested call s:load_session()
    autocmd VimLeavePre * call s:save_session()
augroup END

" Format code on save
augroup fmt
  autocmd!
  autocmd BufWritePre *.h,*.c,*.cc,*.hpp,*.cpp undojoin | call s:clang_format()
augroup END

" -----------------------
"     CONFIGURATION
" -----------------------

set hidden
set number relativenumber
set mouse=a
set expandtab
set shiftwidth=4
set tabstop=4
set splitright splitbelow
set timeoutlen=500
set spelllang=en,de
set noshowmode
set termguicolors
set inccommand=nosplit
set guifont=JetBrainsMono:12
colorscheme gruvbox
set undofile
set undodir=~/.local/share/nvim/undo
set switchbuf+=useopen
let g:vimsyn_embed = 'lPr'

set list
set listchars=tab:>-,trail:-,nbsp:+

" Hexokinase
let g:Hexokinase_highlighters = [ 'foregroundfull' ]

" Highlightedyank
let g:highlightedyank_highlight_duration = 200

" Lualine
lua << EOF
local lualine = require('lualine')
lualine.setup{
    options = {
        theme = 'gruvbox',
        section_separators = {},
        component_separators = '|',
        icons_enabled = true,
    },
    sections = {
        lualine_a = { {'mode', upper = true} },
        lualine_b = { {'branch', icon = ''}, { 'diff' } },
        lualine_c = { { 'diagnostics', sources = { 'nvim_lsp' } }, {'filename', file_status = true} },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location'  },
    },
    extensions = { 'fzf' }
}
EOF

" Barbar
let bufferline = {}
let bufferline.icons = v:true
let bufferline.closable = v:false

" FZF
let g:fzf_preview_window = 'right:60%'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g "!{node_modules/*,.git/*}"'

" nvim-lspconfig
lua << EOF
local lspconfig = require('lspconfig')

lspconfig.tsserver.setup{}

lspconfig.clangd.setup{}

lspconfig.pyright.setup{}

lspconfig.texlab.setup{
    settings = {
        latex = {
            build = {
                executable = 'pdflatex',
                onSave = true
            }
        }
    }
}
EOF

" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true
    },
    indent = {
        enable = false -- Currently broken
    }
}
EOF

" completion-nvim
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" nvim-tree.lua
let g:nvim_tree_auto_close = 1
let g:nvim_tree_follow = 1
let g:nvim_tree_git_hl = 1

" vim-mundo
let g:mundo_right = 1

" vim-rooter
let g:rooter_patterns = [ '.git' ]

" -----------------------
"      KEYBINDINGS
" -----------------------
let mapleader=" "
nmap Y y$
nnoremap <silent> <esc>        :noh<CR>
" Buffers
nnoremap <silent> <A-s>        :BufferPick<CR>

nnoremap <silent> <Space>bd    :BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl    :BufferOrderByLanguage<CR>

nnoremap <silent> <A-k>        :BufferPrevious<CR>
nnoremap <silent> <A-j>        :BufferNext<CR>

nnoremap <silent> <A-<>        :BufferMovePrevious<CR>
nnoremap <silent> <A->>        :BufferMoveNext<CR>

nnoremap <silent> <A-1>        :BufferGoto 1<CR>
nnoremap <silent> <A-2>        :BufferGoto 2<CR>
nnoremap <silent> <A-3>        :BufferGoto 3<CR>
nnoremap <silent> <A-4>        :BufferGoto 4<CR>
nnoremap <silent> <A-5>        :BufferGoto 5<CR>
nnoremap <silent> <A-6>        :BufferGoto 6<CR>
nnoremap <silent> <A-7>        :BufferGoto 7<CR>
nnoremap <silent> <A-8>        :BufferGoto 8<CR>
nnoremap <silent> <A-9>        :BufferLast<CR>

nnoremap <silent> <A-q>        :BufferClose<CR>

" splits
nnoremap <silent> <leader>sh   :vs<CR>
nnoremap <silent> <leader>sj   :sp<CR>
nnoremap <silent> <leader>sk   :sp<CR>
nnoremap <silent> <leader>sl   :vs<CR>

" terminal
tnoremap <silent> <C-h>        <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <silent> <C-j>        <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <silent> <C-k>        <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <silent> <C-l>        <C-\><C-n>:TmuxNavigateRight<CR>
tnoremap <expr><silent> <A-k>  (&buflisted == 1 ? '<C-\><C-n>:BufferPrevious<CR>' : '')
tnoremap <expr><silent> <A-j>  (&buflisted == 1 ? '<C-\><C-n>:BufferNext<CR>' : '')
tnoremap <expr><silent> <A-q>  (&buflisted == 1 ? '<C-\><C-n>:BufferClose!<CR>' : '<C-\><C-n>:bd!<CR>')
nnoremap <expr><silent> <C-t>  (bufexists('toggleterm') == 1 ? ':sbuffer toggleterm<CR>' : ':sp<CR>:resize 10<CR>:term<CR>:set nobuflisted<CR>:file toggleterm<CR>i')
tnoremap <expr><silent> <C-t>  (&buflisted == 1 ? '' : '<C-\><C-n>:bd!<CR>')

" FZF
nnoremap <silent> <C-f>        :Files<CR>

" LSP
nnoremap <silent> gd           :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD           :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gF           :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> K            :call <SID>show_documentation()<CR>

" completion-nvim
inoremap <expr> <Tab>          pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab>        pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <C-space>             <C-n>

" nvim-tree.lua
nnoremap <silent> <C-n>        :NvimTreeToggle<CR>

" vim-mundo
nnoremap <silent> U            :MundoToggle<CR>

" other
nnoremap <expr> k              (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j              (v:count == 0 ? 'gj' : 'j')
nnoremap Ö                     {
nnoremap Ä                     }
