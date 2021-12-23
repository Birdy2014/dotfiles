--[[

External Requirements:
- Neovim 0.6
- Terminal with support for unicode and truecolors
- Language Servers:
    - clangd
    - pyright
    - rust_analyzer
    - tsserver
    - texlab
- Debug Adapters (start debugging with F5)
    - lldb (with /bin/lldb-vscode binary)
    - debugpy

]]

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
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'machakann/vim-highlightedyank'
    use { 'rrethy/vim-hexokinase', run = 'make hexokinase' }
    use { 'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'arkav/lualine-lsp-progress', requires = 'nvim-lualine/lualine.nvim' }
    use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use 'akinsho/nvim-toggleterm.lua'
    use 'glepnir/dashboard-nvim'
    use 'folke/which-key.nvim'
    use 'luukvbaal/stabilize.nvim'

    -- Navigation
    use 'christoomey/vim-tmux-navigator'
    use 'phaazon/hop.nvim'
    use 'michaeljsmith/vim-indent-object'
    use 'nacro90/numb.nvim'
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }
    use { 'nvim-telescope/telescope-project.nvim', requires = 'nvim-telescope/telescope.nvim' }

    -- Coding
    use 'neovim/nvim-lspconfig'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-calc'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'kdheepak/cmp-latex-symbols'
    use 'saadparwaiz1/cmp_luasnip'
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'sbdchd/neoformat'
    use 'simrat39/symbols-outline.nvim'
    use { 'TimUntersberger/neogit', requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim', 'sindrets/diffview.nvim' } }
    use 'ray-x/lsp_signature.nvim'
    use 'folke/trouble.nvim'
    use 'folke/todo-comments.nvim'
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }
    use 'mtikekar/vim-bsv'
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
    use { 'theHamsta/nvim-dap-virtual-text', requires = { 'mfussenegger/nvim-dap' } }
    use 'tikhomirov/vim-glsl'
    use 'digitaltoad/vim-pug'

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
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.opt.showbreak = '↪ '
vim.opt.scrolloff = 1

--- Hexokinase
vim.g.Hexokinase_highlighters = { 'foregroundfull' }
vim.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

--- Highlightedyank
vim.g.highlightedyank_highlight_duration = 200

--- vimwiki
vim.cmd('autocmd FileType vimwiki setlocal spell')
vim.cmd('autocmd FileType vimwiki hi! link VimwikiSuperScript Normal')

vim.g.vimwiki_list = {
    {
        path = '$HOME/vimwiki',
        syntax = 'default',
        template_path = '$HOME/vimwiki/templates',
        template_default = 'default',
        template_ext = '.html',
        nested_syntaxes = {
            python = 'python',
            cpp = 'cpp',
            java = 'java',
            bsv = 'bsv',
        }
    }
}

--- stabilize
require("stabilize").setup()

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
        lualine_c = { { 'diagnostics', sources = { 'nvim_lsp' } }, { 'lsp_progress' }, {'filename', file_status = true} },
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

local servers = { 'clangd', 'pyright', 'rust_analyzer', 'tsserver' }
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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

--- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = false
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

local lspkind = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

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
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'latex_symbols' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end
            }
        },
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind[vim_item.kind]
            vim_item.menu = ({
                calc = "[Calc]",
                nvim_lsp = "[LSP]",
                path = "[Path]",
                luasnip = "[Snippet]",
                latex_symbols = "[Latex]",
                buffer = "[Buffer]",
            })[entry.source.name]
            return vim_item
        end
    },
    sorting = {
        comparators = {
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            --cmp.config.compare.exact,
            --cmp.config.compare.kind,
            --cmp.config.compare.sort_text,
            --cmp.config.compare.length,
            --cmp.config.compare.order,
        },
    },
    experimental = {
        ghost_text = true
    }
})

cmp.setup.cmdline('/', {
    sources = {
        {
            name = 'buffer',
            option = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end
            }
        }
    }
})

cmp.setup.cmdline(':', {
    sources = {
        { name = 'path' },
        { name = 'cmdline' }
    }
})


--- nvim-tree.lua
vim.g.nvim_tree_git_hl = 1
vim.cmd("autocmd BufWinEnter NvimTree setlocal cursorline")
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
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
    filters = {
        dotfiles = false,
        custom = {
            '.git',
            'node_modules',
            '.cache',
            '.ccls-cache'
        },
    },
    view = {
        width = 40,
        mappings = {
            custom_only = true,
            list = {
                { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
                { key = {"<2-RightMouse>", "<C-]>"},    cb = tree_cb("cd") },
                { key = "<C-v>",                        cb = tree_cb("vsplit") },
                { key = "<C-x>",                        cb = tree_cb("split") },
                { key = "<",                            cb = tree_cb("prev_sibling") },
                { key = ">",                            cb = tree_cb("next_sibling") },
                { key = "P",                            cb = tree_cb("parent_node") },
                { key = "<BS>",                         cb = tree_cb("close_node") },
                { key = "<S-CR>",                       cb = tree_cb("close_node") },
                { key = "<Tab>",                        cb = tree_cb("preview") },
                { key = "K",                            cb = tree_cb("first_sibling") },
                { key = "J",                            cb = tree_cb("last_sibling") },
                { key = "I",                            cb = tree_cb("toggle_ignored") },
                { key = "H",                            cb = tree_cb("toggle_dotfiles") },
                { key = "R",                            cb = tree_cb("refresh") },
                { key = "a",                            cb = tree_cb("create") },
                { key = "d",                            cb = tree_cb("remove") },
                { key = "r",                            cb = tree_cb("rename") },
                { key = "<C-r>",                        cb = tree_cb("full_rename") },
                { key = "x",                            cb = tree_cb("cut") },
                { key = "c",                            cb = tree_cb("copy") },
                { key = "p",                            cb = tree_cb("paste") },
                { key = "y",                            cb = tree_cb("copy_name") },
                { key = "Y",                            cb = tree_cb("copy_path") },
                { key = "gy",                           cb = tree_cb("copy_absolute_path") },
                { key = "[c",                           cb = tree_cb("prev_git_item") },
                { key = "]c",                           cb = tree_cb("next_git_item") },
                { key = "-",                            cb = tree_cb("dir_up") },
                { key = "s",                            cb = tree_cb("system_open") },
                { key = "q",                            cb = tree_cb("close") },
                { key = "g?",                           cb = tree_cb("toggle_help") },
            }
        }
    }
}

--- vim-mundo
vim.g.mundo_right = 1

--- nvim-toggleterm
require("toggleterm").setup{
    size = function(term)
        if term.direction == 'horizontal' then
            return 15
        elseif term.direction == 'vertical' then
            return vim.o.columns * 0.3
        end
    end,
    open_mapping = '<c-t>',
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = '1',
    start_in_insert = true,
    persist_size = true,
    direction = 'vertical',
    close_on_exit = true,
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

--- nvim-dap
local dap = require('dap')
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.adapters.python = {
    type = 'executable';
    command = '/bin/python';
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch';
        name = "Launch file";

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}"; -- This configuration will launch the current file if used.
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python'
            end
        end;
    },
}

--- nvim-dap-ui
require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
    },
    sidebar = {
    -- You can change the order of elements in the sidebar
        elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
            },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 00.25 },
        },
        size = 40,
        position = "left", -- Can be "left", "right", "top", "bottom"
    },
    tray = {
        elements = { "repl" },
        size = 10,
        position = "bottom", -- Can be "left", "right", "top", "bottom"
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

--- nvim-dap-virtual-text
require('nvim-dap-virtual-text').setup{}

--- hop.nvim
local hop = require('hop')
hop.setup()

--- which-key.nvim
vim.g.mapleader = ' '

local dap = require('dap')
local dapui = require('dapui')

function close_buffer(name)
    local nr = vim.fn.bufnr(name)
    if nr > 0 then
        vim.cmd('bw ' .. nr)
    end
end

function SaveSession()
    close_buffer('NvimTree')
    close_buffer('DAP Scopes')
    close_buffer('DAP Breakpoints')
    close_buffer('DAP Stacks')
    close_buffer('DAP Watches')
    close_buffer('[dap-repl]')
    vim.cmd('SessionSave')
end

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
        s = { SaveSession, 'Save Session' },
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
    -- debug
    ['<leader>d'] = {
        name = 'Debug',
        t = { dapui.toggle, 'Toggle DAP UI' },
        b = { dap.toggle_breakpoint, 'Toggle breakpoint' },
        B = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Set breakpoint condition' },
        p = { function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, 'Set breakpoint log' },
        r = { dap.repl.open, 'Open REPL' },
        l = { dap.run_last, 'Run last' },
    },
    ['<F5>'] = { dap.continue, 'Continue' },
    ['<F10>'] = { dap.step_over, 'Step over' },
    ['<F11>'] = { dap.step_into, 'Step into' },
    ['<F12>'] = { dap.step_out, 'Step out' },
    -- hop
    ['s'] = { hop.hint_char2, 'Hop char2' },
    ['S'] = { hop.hint_words, 'Hop word' },
    -- other
    ['Y'] = { 'y$', 'Yank to end', noremap = false },
    ['<esc>'] = { '<cmd>noh<cr>', 'Hide search highlight' },
    ['k'] = { '(v:count == 0 ? "gk" : "k")', 'Up', expr = true },
    ['j'] = { '(v:count == 0 ? "gj" : "j")', 'Down', expr = true },
    ['<'] = { '<gv', 'Unindent', mode = 'v' },
    ['>'] = { '>gv', 'Indent', mode = 'v' },
    ['ö'] = { '[', '', noremap = false },
    ['ä'] = { ']', '', noremap = false },
    ['öö'] = { '[[', '' },
    ['ää'] = { ']]', '' },
    ['Ö'] = { '{', '', noremap = false },
    ['Ä'] = { '}', '', noremap = false },
})
