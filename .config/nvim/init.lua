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
    use 'glepnir/dashboard-nvim'
    use 'folke/which-key.nvim'

    -- Navigation
    use 'christoomey/vim-tmux-navigator'
    use 'justinmk/vim-sneak'
    use 'michaeljsmith/vim-indent-object'
    use 'nacro90/numb.nvim'
    use 'haya14busa/vim-asterisk'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }
    use { 'nvim-telescope/telescope-project.nvim', requires = 'nvim-telescope/telescope.nvim' }

    -- Coding
    use 'sheerun/vim-polyglot'
    use 'neovim/nvim-lspconfig'
    use { 'nvim-treesitter/nvim-treesitter', branch = '0.5-compat', run = ':TSUpdate' }
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-calc'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'sbdchd/neoformat'
    use 'simrat39/symbols-outline.nvim'
    use { 'TimUntersberger/neogit', requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim', 'sindrets/diffview.nvim' } }
    use 'ray-x/lsp_signature.nvim'
    use 'folke/trouble.nvim'
    use 'folke/todo-comments.nvim'
    use { 'nvim-treesitter/nvim-treesitter-textobjects', branch = '0.5-compat' }

    -- Other
    use 'vimwiki/vimwiki'
    use 'simnalamburt/vim-mundo'
    use { 'nvim-telescope/telescope-symbols.nvim', requires = 'nvim-telescope/telescope.nvim' }
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

--- Format code on save
vim.cmd [[
augroup fmt
    autocmd!
    autocmd BufWritePre * call g:Clang_format()
augroup END
]]

-- Vimwiki hide superscript
vim.cmd('autocmd FileType vimwiki hi! link VimwikiSuperScript Normal')

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
vim.opt.spelllang = { 'en', 'de' }
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
vim.g.bufferline = {
    closable = false
}

--- nvim-lspconfig
local lspconfig = require('lspconfig')

local servers = { 'ccls', 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
end

lspconfig.texlab.setup{
    settings = {
        latex = {
            build = {
                executable = 'pdflatex',
                onSave = true
            }
        }
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

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

--- nvim-cmp
vim.opt.shortmess:append('c')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require('luasnip')

local cmp = require('cmp')

cmp.setup({
    completion = {
        completeopt = 'menuone,noselect',
    },
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = 'calc' },
        { name = 'nvim_lsp' },
        {
            name = 'buffer',
            opts = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end
            }
        },
        { name = 'path' },
        --{ name = 'luasnip' },
    }
})

--- nvim-tree.lua
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
vim.cmd("autocmd BufWinEnter NvimTree setlocal cursorline")
require('nvim-tree').setup {
    auto_close = true,
    hijack_cursor = true,
    update_cwd = true,
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },
    update_focused_file = {
        enable = true,
    },
    view = {
        width = 40
    }
}

--- vim-mundo
vim.g.mundo_right = 1

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

--- telescope
require('telescope').load_extension('project')

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

-- trouble.nvim
require('trouble').setup {
    position = 'right'
}

--- todo-comments.nvim
require('todo-comments').setup()

--- nvim-treesitter-textobjects
require('nvim-treesitter.configs').setup {
    textobjects = {
        select = {
            enable = true,
            lookahead = true,

            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@comment.outer',
                ['ic'] = '@comment.inner',
            },
        },
    },
}

--- which-key.nvim
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
        l = { '<cmd>Telescope live_grep<cr>', 'Find Lines' },
        b = { '<cmd>Telescope buffers<cr>', 'Find Buffers' },
        h = { '<cmd>Telescope help_tags<cr>', 'Find Help' },
        r = { '<cmd>Telescope file_browser<cr>', 'File Browser' },
        s = { '<cmd>Telescope symbols<cr>', 'Find Symbols' },
        p = { '<cmd>Telescope project<cr>', 'Find Projects' },
        m = { '<cmd>Telescope man_pages<cr>', 'Find Man Pages' },
    },
    -- LSP
    ['K'] = { vim.lsp.buf.hover, 'Hover' },
    ['g'] = {
        h = { '<cmd>TroubleToggle lsp_references<cr>', 'References' },
        a = { vim.lsp.buf.code_action, 'Code Action' },
        r = { vim.lsp.buf.rename, 'Rename symbol' },
        D = { vim.lsp.buf.declaration, 'Declaration' },
        d = { vim.lsp.buf.definition, 'Definition' },
        i = { vim.lsp.buf.implementation, 'Implementation' },
    },
    ['[d'] = { vim.lsp.diagnostic.goto_prev, 'Previous Diagnostic' },
    [']d'] = { vim.lsp.diagnostic.goto_next, 'Next Diagnostic' },
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
        T = { '<cmd>TroubleToggle todo<cr>', 'Toggle Todos' },
        u = { '<cmd>MundoToggle<cr>', 'Toggle Undo Tree' },
        s = { '<cmd>SymbolsOutline<cr>', 'Toggle Symbols Outline' },
        g = { '<cmd>Neogit kind=split<cr>', 'Neogit' },
        d = { '<cmd>TroubleToggle lsp_document_diagnostics<cr>', 'Document Diagnostics' },
        D = { '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>', 'Workspace Diagnostics' },
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
