--[[

External Requirements:
- Neovim 0.7+
- Terminal with support for unicode and truecolors
- A patched font from https://www.nerdfonts.com/
- Language Servers:
    - clangd
    - pyright
    - rust_analyzer
    - tsserver
    - texlab
- Debug Adapters (start debugging with F5)
    - lldb (with /bin/lldb-vscode binary)
    - debugpy
- python and the 'pynvim' python-package (for vim-mundo)

Run :PackerSync after changing the config file and to update plugins.

]]

--- -----------------------
---        PLUGINS
--- -----------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.api.nvim_command('packadd packer.nvim')
    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            require('packer').sync()
        end
    })
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- Dependencies
    use {
        'sindrets/diffview.nvim',
        module = 'diffview'
    }

    use {
        'nvim-lua/plenary.nvim',
        module = 'plenary'
    }

    -- Theme / Statusbars / Visual
    use {
        'eddyekofo94/gruvbox-flat.nvim',
        config = function()
            vim.cmd('colorscheme gruvbox-flat')
        end
    }

    use {
        'norcalli/nvim-colorizer.lua',
        run = [[bash -c 'patch lua/colorizer.lua <<EOF
diff --git a/lua/colorizer.lua b/lua/colorizer.lua
index e47e079..4e6afde 100644
--- a/lua/colorizer.lua
+++ b/lua/colorizer.lua
@@ -17,7 +17,7 @@ local COLOR_MAP
 local COLOR_TRIE
 local COLOR_NAME_MINLEN, COLOR_NAME_MAXLEN
 local COLOR_NAME_SETTINGS = {
-	lowercase = false;
+	lowercase = true;
 	strip_digits = false;
 }

        EOF']],
        config = function()
            require 'colorizer'.setup({
                '*',
                css = {
                    names = true,
                    css = true,
                },
                sass = {
                    names = true,
                    css = true,
                },
                scss = {
                    names = true,
                    css = true,
                },
            }, {
                names = false,
                lowercase = true,
                RRGGBBAA = true,
                mode = 'foreground',
            })
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'arkav/lualine-lsp-progress'
        },
        config = function()
            local function package_info_status()
                local status = require('package-info').get_status()
                if status == ' ' then
                    return ''
                end
                return status
            end

            local function lsp_client_names()
                local client_names = {}
                for _, client in ipairs(vim.lsp.get_active_clients()) do
                    table.insert(client_names, client.name)
                end
                return table.concat(client_names, ",")
            end

            local lualine = require('lualine')
            lualine.setup {
                options = {
                    theme = 'gruvbox-flat',
                    section_separators = {},
                    component_separators = '|',
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = { {'mode', upper = true} },
                    lualine_b = { {'branch', icon = ''}, { 'diff' } },
                    lualine_c = { { 'filename', file_status = true }, { 'diagnostics', sources = { 'nvim_diagnostic' } }, { lsp_client_names }, { 'lsp_progress' }, { package_info_status } },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location'  },
                },
                extensions = { 'nvim-tree', 'toggleterm', 'symbols-outline' }
            }
        end
    }

    use {
        'romgrk/barbar.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            vim.api.nvim_create_autocmd('BufWinEnter', {
                pattern = 'NvimTree*',
                callback = function()
                    vim.wo.cursorline = true
                end
            })
            local tree_cb = require'nvim-tree.config'.nvim_tree_callback
            require('nvim-tree').setup {
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
                    dotfiles = true,
                    custom = {
                        '.git',
                        'node_modules',
                        '.cache',
                        '.ccls-cache'
                    },
                },
                actions = {
                    change_dir = {
                        global = true
                    },
                    open_file = {
                        resize_window = true
                    },
                },
                view = {
                    width = 40,
                    mappings = {
                        custom_only = true,
                        list = {
                            { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
                            { key = {"c", "<2-RightMouse>"},        cb = tree_cb("cd") },
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
                            { key = "D",                            cb = tree_cb("remove") },
                            { key = "r",                            cb = tree_cb("rename") },
                            { key = "<C-r>",                        cb = tree_cb("full_rename") },
                            { key = "d",                            cb = tree_cb("cut") },
                            { key = "y",                            cb = tree_cb("copy") },
                            { key = "p",                            cb = tree_cb("paste") },
                            { key = "Y",                            cb = tree_cb("copy_path") },
                            { key = "gy",                           cb = tree_cb("copy_name") },
                            { key = "[c",                           cb = tree_cb("prev_git_item") },
                            { key = "]c",                           cb = tree_cb("next_git_item") },
                            { key = "u",                            cb = tree_cb("dir_up") },
                            { key = "s",                            cb = tree_cb("system_open") },
                            { key = "q",                            cb = tree_cb("close") },
                            { key = "g?",                           cb = tree_cb("toggle_help") },
                        }
                    }
                },
                renderer = {
                    highlight_git = true,
                }
            }
        end
    }

    use {
        'akinsho/toggleterm.nvim',
        keys = '<c-t>',
        config = function()
            require('toggleterm').setup {
                size = function(term)
                    if term.direction == 'horizontal' then
                        return 15
                    elseif term.direction == 'vertical' then
                        return vim.o.columns * 0.3
                    end
                end,
                open_mapping = '<c-t>',
                shade_terminals = true,
                start_in_insert = true,
                persist_size = true,
                direction = 'vertical',
                close_on_exit = true,
            }
        end
    }

    use {
        'goolord/alpha-nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            local alpha_config = require('alpha.themes.theta').config
            local dashboard = require('alpha.themes.dashboard')
            alpha_config.layout[6].val = {
                { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
                { type = 'padding', val = 1 },
                dashboard.button('e', '  New file', '<cmd>ene<cr>'),
                dashboard.button('SPC f f', '  Find file', '<cmd>Telescope find_files<cr>'),
                dashboard.button('SPC f p', '  Open Projects', '<cmd>Telescope project<cr>'),
                dashboard.button('SPC f m', 'ﲉ  Find Man Pages', '<cmd>Telescope man_pages sections=["1","2","3","4","5","6","7","8","9"]<cr>'),
                dashboard.button('SPC t t', 'פּ  Open File Tree', '<cmd>NvimTreeToggle<cr>'),
                dashboard.button('u', '  Update plugins' , '<cmd>PackerSync<cr>'),
                dashboard.button('q', '  Quit' , '<cmd>qa<cr>'),
            }
            require('alpha').setup(alpha_config)
        end
    }

    use {
        'luukvbaal/stabilize.nvim',
        config = function()
            require("stabilize").setup()
        end
    }

    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup {
                buftype_exclude = { 'terminal' },
                filetype_exclude = { 'alpha', 'packer', 'help', 'man', 'NvimTree' }
            }
        end
    }

    -- Navigation
    use 'christoomey/vim-tmux-navigator'

    use {
        'phaazon/hop.nvim',
        config = function()
            require('hop').setup()
        end
    }

    use 'michaeljsmith/vim-indent-object'

    use {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup{
               show_numbers = true,
               show_cursorline = true
            }
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        module = { 'telescope', 'telescope.builtin' },
        requires = { 'nvim-lua/plenary.nvim' }
    }

    use {
        'nvim-telescope/telescope-project.nvim',
        requires = 'nvim-telescope/telescope.nvim',
        after = 'telescope.nvim',
        config = function()
            require('telescope').load_extension('project')
        end
    }

    -- Coding
    use {
        'neovim/nvim-lspconfig',
        requires = 'hrsh7th/cmp-nvim-lsp',
        config = function()
            local lspconfig = require('lspconfig')

            function on_lsp_attach()
                local clients = vim.lsp.get_active_clients()
                local bufnr = vim.api.nvim_get_current_buf()

                for _, client in ipairs(clients) do
                    if client.resolved_capabilities.goto_definition then
                        vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
                    end

                    if client.resolved_capabilities.document_formatting then
                        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
                    end
                end
            end

            local servers = { 'clangd', 'pyright', 'rust_analyzer', 'tsserver', 'bashls' }

            local server_config = {
                rust_analyzer = {
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            command = 'clippy',
                            --extraArgs = { '--offline' }
                        }
                    }
                }
            }

            for _, lsp in ipairs(servers) do
                local conf = {
                    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                    on_attach = on_lsp_attach,
                    settings = server_config[lsp] or {}
                }
                lspconfig[lsp].setup(conf)
            end

            lspconfig.texlab.setup {
                settings = {
                    latex = {
                        build = {
                            executable = 'pdflatex',
                            onSave = true
                        }
                    }
                },
                capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                on_attach = on_lsp_attach
            }

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

            for type, icon in pairs(signs) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = 'nvim-treesitter/nvim-treesitter-refactor',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'bash', 'c', 'c_sharp', 'cmake', 'comment', 'cpp', 'css', 'cuda', 'dart', 'dockerfile', 'dot', 'fish', 'gdscript', 'glsl', 'go', 'gomod', 'help', 'hjson', 'html', 'java', 'javascript', 'jsdoc', 'json', 'json5', 'kotlin', 'latex', 'lua', 'make', 'markdown', 'ninja', 'nix', 'php', 'pug', 'python', 'rasi', 'regex', 'rust', 'scss', 'toml', 'tsx', 'typescript', 'verilog', 'vim', 'vue', 'yaml' },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true, -- Needed for spellchecker to distinguish between code and comment
                },
                indent = {
                    enable = false
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        clear_on_cursor_move = true,
                    },
                    --highlight_current_scope = { enable = true }, -- Maybe enable when #31 is merged
                }
            }

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('treesitter-context').setup {
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        'class',
                        'function',
                        'method',
                        -- 'for', -- These won't appear in the context
                        -- 'while',
                        -- 'if',
                        -- 'switch',
                        -- 'case',
                    },
                },
                exact_patterns = {
                    -- Example for a specific filetype with Lua patterns
                    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
                    -- exactly match "impl_item" only)
                    -- rust = true,
                },
            }
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = 'nvim-treesitter/nvim-treesitter',
        after = 'nvim-treesitter',
        config = function()
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
        end
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-calc',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'kdheepak/cmp-latex-symbols',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
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

            local mapping_tab = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end

            local mapping_shift_tab = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end

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
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(mapping_tab, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(mapping_shift_tab, { "i", "s" }),
                },
                sources = {
                    { name = 'calc' },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'latex_symbols' },
                    { name = 'neorg' },
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                            keyword_pattern = [[\k\+]]
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
                            neorg = "[Neorg]",
                            buffer = "[Buffer]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.recently_used,
                        cmp.config.compare.score,
                        cmp.config.compare.length,
                        cmp.config.compare.offset,
                        --cmp.config.compare.exact,
                        --cmp.config.compare.kind,
                        --cmp.config.compare.sort_text,
                        --cmp.config.compare.order,
                    },
                },
                experimental = {
                    ghost_text = true
                }
            })

            cmp.setup.cmdline('/', {
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(mapping_tab, { "c" }),
                    ["<S-Tab>"] = cmp.mapping(mapping_shift_tab, { "c" }),
                },
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
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(mapping_tab, { "c" }),
                    ["<S-Tab>"] = cmp.mapping(mapping_shift_tab, { "c" }),
                },
                sources = {
                    --{ name = 'path' },
                    { name = 'cmdline' }
                }
            })
        end
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
        'simrat39/symbols-outline.nvim',
        cmd = 'SymbolsOutline',
        config = function()
            vim.g.symbols_outline = {
                width = 15,
            }
        end
    }

    use {
        'TimUntersberger/neogit',
        requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
        cmd = 'Neogit',
        config = function()
            require('neogit').setup{
                integrations = {
                    diffview = true
                }
            }
        end
    }

    use {
        'ray-x/lsp_signature.nvim',
        config = function()
            require('lsp_signature').setup()
        end
    }

    use {
        'folke/trouble.nvim',
        cmd = 'TroubleToggle',
        config = function()
            require('trouble').setup {
                position = 'right'
            }
        end
    }

    use {
        'folke/todo-comments.nvim',
        after = 'trouble.nvim',
        config = function()
            require('todo-comments').setup()
        end
    }

    use {
        'mfussenegger/nvim-dap',
        config = function()
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
                    type = 'python';
                    request = 'launch';
                    name = "Launch file";

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}";
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/env/bin/python') == 1 then
                            return cwd .. '/env/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end;
                },
            }
        end
    }

    use {
        'rcarriga/nvim-dap-ui',
        requires = 'mfussenegger/nvim-dap',
        config = function()
            require("dapui").setup {
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
            }
        end
    }

    use {
        'theHamsta/nvim-dap-virtual-text',
        requires = 'mfussenegger/nvim-dap',
        config = function()
            require('nvim-dap-virtual-text').setup()
        end
    }

    use {
        "vuki656/package-info.nvim",
        requires = "MunifTanjim/nui.nvim",
        config = function()
            require('package-info').setup()
        end
    }

    -- Languages
    use {
        'tikhomirov/vim-glsl',
        ft = 'glsl'
    }

    use {
        'digitaltoad/vim-pug',
        ft = 'pug'
    }

    use {
        'lluchs/vim-wren',
        ft = 'wren'
    }

    use {
        'mtikekar/vim-bsv',
        ft = 'bsv'
    }

    -- Other
    use {
        'vimwiki/vimwiki',
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'vimwiki',
                callback = function()
                    vim.wo.spell = true
                    vim.cmd('hi! link VimwikiSuperScript Normal')
                end
            })

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
        end
    }

    use {
        'nvim-neorg/neorg',
        requires =  'nvim-lua/plenary.nvim',
        after = 'nvim-treesitter',
        ft = 'norg',
        cmd = 'NeorgStart',
        config = function()
            local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

            parser_configs.norg_meta = {
                install_info = {
                    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
                    files = { "src/parser.c" },
                    branch = "main"
                },
            }

            parser_configs.norg_table = {
                install_info = {
                    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
                    files = { "src/parser.c" },
                    branch = "main"
                },
            }

            require('nvim-treesitter.install').update { 'norg', 'norg_meta', 'norg_table' }

            require('neorg').setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.norg.dirman"] = {
                        config = {
                            workspaces = {
                                workspace = "~/Documents/neorg",
                            },
                            autochdir = true,
                            index = 'index.norg',
                        }
                    },
                    ["core.norg.concealer"] = {
                        config = {
                            preset = 'diamond'
                        }
                    },
                    ["core.norg.completion"] = {
                        config = {
                            engine = "nvim-cmp"
                        }
                    },
                    ["core.norg.qol.toc"] = {
                        config = {
                            toc_split_placement = "left"
                        }
                    },
                    ["core.keybinds"] = {
                        config = {
                            default_keybinds = false,
                            hook = function(keybinds)
                                keybinds.remap_event("norg", "n", "<cr>", "core.norg.esupports.hop.hop-link")
                                keybinds.remap_event("toc-split", "n", "<cr>", "core.norg.qol.toc.hop-toc-link")
                                keybinds.remap_event("toc-split", "n", "q", "core.norg.qol.toc.close")
                                keybinds.remap_event("toc-split", "n", "<esc>", "core.norg.qol.toc.close")
                            end,
                        }
                    }
                }
            }
        end,
    }

    use {
        'simnalamburt/vim-mundo',
        cmd = 'MundoToggle',
        config = function()
            vim.g.mundo_right = 1
        end
    }

    use {
        'nvim-telescope/telescope-symbols.nvim',
        requires = 'nvim-telescope/telescope.nvim',
        after = 'telescope.nvim'
    }

    use {
        'ojroques/vim-oscyank',
        config = function()
            vim.api.nvim_create_autocmd('TextYankPost', {
                callback = function()
                    if vim.v.event.regname == '+' then
                        vim.cmd 'OSCYankReg +'
                    end
                end
            })
        end
    }

    use {
        'rmagatti/auto-session',
        config = function()
            vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

            function restore_nvim_tree()
                if vim.fn.bufexists('NvimTree_1') == 1 then
                    require('nvim-tree').open()
                end
            end

            function close_dapui()
                if not packer_plugins['dapui'] or not packer_plugins['dapui'].loaded then
                    return
                end
                local dapui = require('dapui')
                dapui.close()
            end

            require('auto-session').setup {
                log_level = 'info',
                auto_session_suppress_dirs = { '~/' },
                auto_session_enable_last_session = false,
                auto_save_enabled = true,
                auto_restore_enabled = false,
                pre_save_cmds = { close_dapui },
                post_restore_cmds = { restore_nvim_tree },
            }
        end
    }

    use {
        'Darazaki/indent-o-matic',
        config = function()
            require('indent-o-matic').setup {
            max_lines = 2048,
            standard_widths = { 2, 4, 8 },
        }
        end
    }

    use {
        'folke/which-key.nvim',
        after = {
            'nvim-dap',
            'nvim-dap-ui',
            'hop.nvim'
        },
        config = function()
            vim.g.mapleader = ' '

            local dap = require('dap')
            local dapui = require('dapui')
            local hop = require('hop')

            local wk = require('which-key')

            wk.setup {
                plugins = {
                    marks = true,
                    registers = true,
                    spelling = {
                        enabled = true,
                    }
                }
            }

            wk.register {
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
                    s = { '<cmd>SaveSession<cr>', 'Save Session' },
                    l = { '<cmd>RestoreSession<cr>', 'Load Session' },
                    d = { '<cmd>DeleteSession<cr>', 'Delete Session' },
                },
                -- Telescope
                ['<leader>f'] = {
                    name = 'Find',
                    f = { '<cmd>Telescope find_files<cr>', 'Find Files' },
                    l = { '<cmd>Telescope live_grep<cr>', 'Find Lines' },
                    b = { '<cmd>Telescope buffers<cr>', 'Find Buffers' },
                    h = { '<cmd>Telescope help_tags<cr>', 'Find Help' },
                    s = { '<cmd>Telescope symbols<cr>', 'Find Symbols' },
                    p = { '<cmd>Telescope project<cr>', 'Find Projects' },
                    m = { function() require('telescope.builtin').man_pages({ sections = { "1", "2", "3", "4", "5", "6", "7", "8", "9" } }) end, 'Find Man Pages' },
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
                ['[d'] = { vim.diagnostic.goto_prev, 'Previous Diagnostic' },
                [']d'] = { vim.diagnostic.goto_next, 'Next Diagnostic' },
                -- toggle
                ['<leader>t'] = {
                    name = 'Toggle',
                    t = { '<cmd>NvimTreeToggle<cr>', 'Toggle NvimTree' },
                    T = { '<cmd>TroubleToggle todo<cr>', 'Toggle Todos' },
                    u = { '<cmd>MundoToggle<cr>', 'Toggle Undo Tree' },
                    s = { '<cmd>SymbolsOutline<cr>', 'Toggle Symbols Outline' },
                    g = { '<cmd>Neogit kind=split<cr>', 'Neogit' },
                    d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Diagnostics' },
                    D = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics' },
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
                -- move line
                ['<m-c-k>'] = { ':m -2<cr>==', 'Move line up' },
                ['<m-c-j>'] = { ':m +1<cr>==', 'Move line down' },
                -- other
                ['Y'] = { 'y$', 'Yank to end', noremap = false },
                ['<esc>'] = { '<cmd>noh<cr>', 'Hide search highlight' },
                ['k'] = { '(v:count == 0 ? "gk" : "k")', 'Up', expr = true },
                ['j'] = { '(v:count == 0 ? "gj" : "j")', 'Down', expr = true },
                ['ö'] = { '[', '', noremap = false },
                ['ä'] = { ']', '', noremap = false },
                ['öö'] = { '[[', '' },
                ['ää'] = { ']]', '' },
                ['Ö'] = { '{', '', noremap = false },
                ['Ä'] = { '}', '', noremap = false },
            }

            wk.register({
                -- move line
                ['<m-c-k>'] = { ':m \'<-2<cr>gv=gv', 'Move lines up' },
                ['<m-c-j>'] = { ':m \'>+1<cr>gv=gv', 'Move lines up' },
                -- OSCYank
                ['<leader>y'] = { ':OSCYank<cr>', 'OSC52 Yank' },
                -- Other
                ['<'] = { '<gv', 'Unindent' },
                ['>'] = { '>gv', 'Indent' },
                ['ö'] = { '[', '', noremap = false },
                ['ä'] = { ']', '', noremap = false },
                ['öö'] = { '[[', '' },
                ['ää'] = { ']]', '' },
                ['Ö'] = { '{', '', noremap = false },
                ['Ä'] = { '}', '', noremap = false },
            }, { mode = 'v' })

                -- terminal
            wk.register({
                ['<esc><esc>'] = { '<c-bslash><c-n>', 'Exit Terminal Mode' },
                ['<c-h>'] = { '<c-bslash><c-n><cmd>TmuxNavigateLeft<cr>', 'Window Left' },
                ['<c-j>'] = { '<c-bslash><c-n><cmd>TmuxNavigateDown<cr>', 'Window Down' },
                ['<c-k>'] = { '<c-bslash><c-n><cmd>TmuxNavigateUp<cr>', 'Window Up' },
                ['<c-l>'] = { '<c-bslash><c-n><cmd>TmuxNavigateRight<cr>', 'Window Right' },
                ['<m-k>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferPrevious<cr>" : "")', 'Previous Buffer' },
                ['<m-j>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferNext<cr>" : "")', 'Next Buffer' },
                ['<m-q>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferClose!<cr>" : "<c-bslash><c-n>:bd!<cr>")', 'Close Buffer' },
                ['<m-Q>'] = { '(&buflisted == 1 ? "<c-bslash><c-n><cmd>BufferClose!<cr>" : "<c-bslash><c-n>:bd!<cr>")', 'Close Buffer' },
            }, { mode = 't' })
        end
    }
end)

--- -----------------------
---        AUTOCMDS
--- -----------------------
-- automatically call PackerCompile if init.lua was edited
local config_file = vim.fn.stdpath('config')..'/init.lua'
local compile_file = vim.fn.stdpath('config')..'/plugin/packer_compiled.lua'
if (vim.fn.filereadable(config_file) and vim.fn.filereadable(compile_file) and vim.fn.getftime(config_file) > vim.fn.getftime(compile_file))
then
    require('packer').compile()
end

--- Remove trailing spaces
vim.cmd [[autocmd BufWritePre * %s/\s\+$//e]]

--- Enter insert mode when navigating to a terminal
vim.cmd [[autocmd BufWinEnter,WinEnter term://* startinsert]]

--- Format code on save
vim.api.nvim_create_augroup('fmt', { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = 'fmt',
    callback = function()
        if vim.bo.filetype == 'cpp' and vim.fn.filereadable('.clang-format') == 1 then
            vim.lsp.buf.formatting_sync(nil, 1000)
        end
    end
})

--- auto-close NvimTree
--vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]

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
vim.opt.guifont = 'JetbrainsMono Nerd Font:h10'
vim.opt.background = 'dark'
vim.opt.undofile = true
vim.opt.switchbuf:append('useopen')
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:+'
vim.opt.eadirection = 'hor'
vim.opt.equalalways = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.opt.showbreak = '↪ '
vim.opt.scrolloff = 1
vim.opt.foldlevel = 99
vim.opt.laststatus = 3
vim.opt.updatetime = 2000 -- Workaround to reduce delay for nvim-treesitter-refactor highlight definitions

-- TODO: Put this back into packer config. This crashes barbar on PackerCompile
vim.g.bufferline = {
    closable = false
}

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'),
            timeout=200
        }
    end
})
