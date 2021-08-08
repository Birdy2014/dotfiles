--- -----------------------
---        PLUGINS
--- -----------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.api.nvim_command('packadd packer.nvim')
    vim.cmd('autocmd VimEnter * PackerSync')
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- Theme / Statusbars / Visual
    use 'zetashift/gruvbox-flat.nvim'
    use 'machakann/vim-highlightedyank'
    use { 'rrethy/vim-hexokinase', run = 'make hexokinase' }
    use { 'hoob3rt/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use 'akinsho/nvim-toggleterm.lua'
    use 'tversteeg/registers.nvim'
    use 'glepnir/dashboard-nvim'
    use 'folke/which-key.nvim'

    -- Navigation
    use 'christoomey/vim-tmux-navigator'
    use 'justinmk/vim-sneak'
    use 'michaeljsmith/vim-indent-object'
    use 'nacro90/numb.nvim'
    use 'haya14busa/vim-asterisk'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

    -- Coding
    use 'sheerun/vim-polyglot'
    use 'neovim/nvim-lspconfig'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'hrsh7th/nvim-compe'
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'sbdchd/neoformat'
    use 'simrat39/symbols-outline.nvim'
    use { 'sakhnik/nvim-gdb', run = ':!./install.sh' }
    use { 'TimUntersberger/neogit', requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim', 'sindrets/diffview.nvim' } }
    use 'ray-x/lsp_signature.nvim'

    -- Other
    use 'vimwiki/vimwiki'
    use 'airblade/vim-rooter'
    use 'simnalamburt/vim-mundo'
end)

--- -----------------------
---       FUNCTIONS
--- -----------------------
vim.cmd [[
function! g:Clang_format()
    if &filetype == 'cpp' && filereadable('.clang-format') && executable('clang-format')
        Neoformat clangformat
    endif
endfunction

let g:quickfix_buffer_number = -1
function! g:QuickFixInit()
    if &ft == 'qf'
        wincmd L
        vertical resize 40
        setlocal nobuflisted
        setlocal winfixwidth
        let g:quickfix_buffer_number = bufnr()
        nnoremap <buffer> <silent> j j<CR>:exe 'sbuffer ' g:quickfix_buffer_number<CR>
        nnoremap <buffer> <silent> k k<CR>:exe 'sbuffer ' g:quickfix_buffer_number<CR>
        wincmd =
    endif
endfunction
]]

--- -----------------------
---        AUTOCMDS
--- -----------------------

--- Remove trailing spaces
vim.cmd([[autocmd BufWritePre * %s/\s\+$//e]])

--- Enter insert mode when navigating to a terminal
vim.cmd('autocmd BufWinEnter,WinEnter term://* startinsert')

--- Set cursorline for nvim-tree.lua
vim.cmd('autocmd FileType NvimTree setlocal cursorline')

--- enable spell checking in vimwiki
vim.cmd('autocmd FileType vimwiki setlocal spell')

--- Override python tabstop ftplugin (workaround so Treesitter doesn't break the indentation)
vim.cmd('autocmd BufEnter *.py setlocal tabstop=4')

--- QuickFix
vim.cmd('autocmd FileType qf call s:QuickFixInit()')

--- Format code on save
vim.cmd [[
augroup fmt
    autocmd!
    autocmd BufWritePre * call g:Clang_format()
augroup END
]]

--- -----------------------
---     CONFIGURATION
--- -----------------------
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.timeoutlen = 500
vim.opt.spelllang = 'en,de'
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.inccommand = 'nosplit'
vim.opt.title = true
vim.opt.guifont = 'JetbrainsMono Nerd Font Mono:h11'
vim.opt.background = 'dark'
vim.opt.undofile = true
vim.opt.undodir = vim.fn.getenv('HOME') .. '/.local/share/nvim/undo'
vim.opt.switchbuf:append('useopen')
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:+'
vim.opt.eadirection = 'hor'
vim.opt.equalalways = true
vim.cmd('colorscheme gruvbox-flat')

--- Hexokinase
vim.g.Hexokinase_highlighters = { 'foregroundfull' }
vim.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

--- Highlightedyank
vim.g.highlightedyank_highlight_duration = 200

--- Lualine
local lualine = require('lualine')
lualine.setup{
    options = {
        theme = 'gruvbox-flat',
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
    extensions = { 'nvim-tree' }
}

--- Barbar
vim.cmd [[
let bufferline = {}
let bufferline.icons = v:true
let bufferline.closable = v:false
]]

--- nvim-lspconfig
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

lspconfig.sumneko_lua.setup{
    cmd = { 'lua-language-server' }
}

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

--- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {
        enable = true
    },
    indent = {
        enable = false -- Currently broken
    }
}

--- nvim-compe
vim.opt.shortmess:append('c')
vim.opt.completeopt = 'menuone,noselect'
require('compe').setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'disable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = false;
    };
}

--- nvim-tree.lua
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
vim.cmd("autocmd BufWinEnter NvimTree setlocal cursorline")

--- vim-mundo
vim.g.mundo_right = 1

--- vim-rooter
vim.g.rooter_patterns = { '.git' }

--- nvim-toggleterm
require("toggleterm").setup{
    size = 15,
    open_mapping = '<c-t>',
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = '1',
    start_in_insert = true,
    persist_size = true,
    direction = 'float',
}

--- numb.nvim
require('numb').setup{
   show_numbers = true,
   show_cursorline = true
}

--- diffview.nvim
require('diffview').setup{}

--- neogit
require('neogit').setup{
    integrations = {
        diffview = true
    }
}

--- gitsigns.nvim
require('gitsigns').setup()

--- symbols-outline
vim.g.symbols_outline = {
    width = 15,
}

--- dashboard-nvim
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_header = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
    }
vim.g.dashboard_custom_shortcut = {
    last_session       = 'SPC S l',
    find_history       = 'SPC f h',
    find_file          = 'SPC f f',
    new_file           = 'SPC c n',
    change_colorscheme = 'SPC t c',
    find_word          = 'SPC f g',
    book_marks         = 'SPC f b',
    }

--- lsp_signature
require('lsp_signature').setup()

--- which-key.nvim
local termcode = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return termcode('<c-n>')
    elseif check_back_space() then
        return termcode('<tab>')
    else
        return vim.fn['compe#complete']()
    end
end

local s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return termcode('<c-p>')
    else
        return termcode('<s-tab>')
    end
end

local enter_insert = function()
    if vim.fn.pumvisible() == 1 then
        return vim.fn['compe#confirm']('<cr>')
    else
        return termcode('<cr>')
    end
end

vim.g.mapleader = ' '

local wk = require('which-key')
wk.setup()
wk.register({
    -- buffers
    ['<m-q>'] = { '<cmd>BufferClose<cr>', 'Close Buffer' },
    ['<m-Q>'] = { '<cmd>BufferClose!<cr>', 'Force Close Buffer' },
    ['<m-s>'] = { '<cmd>BufferPick<cr>', 'Pick Buffer' },
    ['<m-k>'] = { '<cmd>BufferPrevious<cr>', 'Previous Buffer' },
    ['<m-j>'] = { '<cmd>BufferNext<cr>', 'Next Buffer' },
    ['<m-K>'] = { '<cmd>BufferMovePrevious<cr>', 'Move Buffer Left' },
    ['<m-J>'] = { '<cmd>BufferMoveNext<cr>', 'Move Buffer Right' },
    ['<m-1>'] = { '<cmd>BufferGoto 1<cr>', 'Buffer 1' },
    ['<m-2>'] = { '<cmd>BufferGoto 2<cr>', 'Buffer 2' },
    ['<m-3>'] = { '<cmd>BufferGoto 3<cr>', 'Buffer 3' },
    ['<m-4>'] = { '<cmd>BufferGoto 4<cr>', 'Buffer 4' },
    ['<m-5>'] = { '<cmd>BufferGoto 5<cr>', 'Buffer 5' },
    ['<m-6>'] = { '<cmd>BufferGoto 6<cr>', 'Buffer 6' },
    ['<m-7>'] = { '<cmd>BufferGoto 7<cr>', 'Buffer 7' },
    ['<m-8>'] = { '<cmd>BufferGoto 8<cr>', 'Buffer 8' },
    ['<m-9>'] = { '<cmd>BufferGoto 9<cr>', 'Buffer 9' },
    ['<m-0>'] = { '<cmd>BufferLast<cr>', 'Last Buffer' },
    ['<leader>b'] = {
        name = 'Sort Buffers',
        d = { '<cmd>BufferOrderByDirectory<cr>', 'By Directory' },
        l = { '<cmd>BufferOrderByLanguage<cr>', 'By Language' },
    },
    -- splits
    ['<leader>s'] = {
        name = 'Splits',
        h = { '<cmd>vs<cr>', 'Split Left' },
        j = { '<cmd>sp<cr>', 'Split Down' },
        k = { '<cmd>sp<cr>', 'Split Up' },
        l = { '<cmd>vs<cr>', 'Split Right' },
    },
    -- sessions
    ['<leader>S'] = {
        name = 'Sessions',
        s = { '<cmd>SessionSave<cr>', 'Save Session' },
        l = { '<cmd>SessionLoad<cr>', 'Load Session' },
    },
    -- Telescope
    ['<leader>f'] = {
        name = 'Find',
        f = { '<cmd>Telescope find_files<cr>', 'Find Files' },
        g = { '<cmd>Telescope live_grep<cr>', 'Find Lines' },
        b = { '<cmd>Telescope buffers<cr>', 'Find Buffers' },
        h = { '<cmd>Telescope help_tags<cr>', 'Find Help' },
        r = { '<cmd>Telescope file_browser<cr>', 'File Browser' },
    },
    -- LSP
    ['K'] = { vim.lsp.buf.hover, 'Hover' },
    ['g'] = {
        h = { vim.lsp.buf.references, 'References' },
        a = { vim.lsp.buf.code_action, 'Code Action' },
        r = { vim.lsp.buf.rename, 'Rename symbol' },
        D = { vim.lsp.buf.declaration, 'Declaration' },
        d = { vim.lsp.buf.definition, 'Definition' },
        i = { vim.lsp.buf.implementation, 'Implementation' },
    },
    ['[d'] = { vim.lsp.diagnostic.goto_prev, 'Previous Diagnostic' },
    [']d'] = { vim.lsp.diagnostic.goto_next, 'Next Diagnostic' },
    -- nvim-compe
    ['<c-space>'] = { vim.fn['compe#complete'], 'Complete', mode = 'i' },
    ['<cr>'] = { enter_insert, 'Confirm Completion', mode = 'i', expr = true },
    ['<c-e>'] = { function() vim.fn['compe#close']('<c-e>') end, 'Close Completion', mode = 'i' },
    ['<tab>'] = { tab_complete, 'Next Completion', mode = 'i', expr = true },
    ['<s-tab>'] = { s_tab_complete, 'Previous Completion', mode = 'i', expr = true },
    -- terminal
    ['<esc><esc>'] = { '<c-bslash><c-n>', 'Exit Terminal Mode', mode = 't' },
    ['<c-h>'] = { '<c-bslash><c-n><cmd>TmuxNavigateLeft<cr>', 'Window Left', mode = 't' },
    ['<c-j>'] = { '<c-bslash><c-n><cmd>TmuxNavigateDown<cr>', 'Window Down', mode = 't' },
    ['<c-k>'] = { '<c-bslash><c-n><cmd>TmuxNavigateUp<cr>', 'Window Up', mode = 't' },
    ['<c-l>'] = { '<c-bslash><c-n><cmd>TmuxNavigateRight<cr>', 'Window Right', mode = 't' },
    ['<a-k>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferPrevious<cr>" : "")', 'Previous Buffer', mode = 't', expr = true },
    ['<a-j>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferNext<cr>" : "")', 'Next Buffer', mode = 't', expr = true },
    ['<a-q>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferClose!<cr>" : "<c-bslash><c-n>:bd!<cr>")', 'Close Buffer', mode = 't', expr = true },
    ['<a-Q>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferClose!<cr>" : "<c-bslash><c-n>:bd!<cr>")', 'Close Buffer', mode = 't', expr = true },
    -- toggle
    ['<leader>t'] = {
        name = 'Toggle',
        t = { '<cmd>NvimTreeToggle<cr>', 'Toggle NvimTree' },
        u = { '<cmd>MundoToggle<cr>', 'Toggle Undo Tree' },
        s = { '<cmd>SymbolsOutline<cr>', 'Toggle Symbols Outline' },
    },
    -- other
    ['Y'] = { 'y$', 'Yank to end', noremap = false },
    ['<esc>'] = { '<cmd>noh<cr>', 'Hide search highlight' },
    ['k'] = { '(v:count == 0 ? "gk" : "k")', 'Up', expr = true },
    ['j'] = { '(v:count == 0 ? "gj" : "j")', 'Down', expr = true },
    ['<'] = { '<gv', 'Unindent', mode = 'v' },
    ['>'] = { '>gv', 'Indent', mode = 'v' },
    ['ö'] = { '[', '', noremap = false },
    ['ä'] = { ']', '', noremap = false },
    ['Ö'] = { '{', '', noremap = false },
    ['Ä'] = { '}', '', noremap = false },
})
