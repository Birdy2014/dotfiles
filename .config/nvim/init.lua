--[[

External Requirements:
- Neovim 0.8+
- Terminal with support for unicode and truecolors
- A patched font from https://www.nerdfonts.com/
- Language Servers:
    - clangd
    - pyright
    - rust_analyzer
    - tsserver
    - texlab
    - bashls
- Debug Adapters (start debugging with F5)
    - lldb (with /bin/lldb-vscode binary)
    - debugpy

Run :PackerSync after changing the config file and to update plugins.

]]

--- -----------------------
---        PLUGINS
--- -----------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

local ran_nvim_notify_setup = false

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

            vim.defer_fn(function()
                vim.g.terminal_color_0 = '#282828'
                vim.g.terminal_color_1 = '#cc241d'
                vim.g.terminal_color_2 = '#98971a'
                vim.g.terminal_color_3 = '#d79921'
                vim.g.terminal_color_4 = '#458588'
                vim.g.terminal_color_5 = '#b16286'
                vim.g.terminal_color_6 = '#689d6a'
                vim.g.terminal_color_7 = '#a89984'
            end, 0)
        end
    }

    use {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup {
                filetypes = {
                    '*',
                    css = { css = true },
                    sass = { css = true },
                    scss = { css = true },
                },
                user_default_options = {
                    RGB = true, -- #RGB hex codes
                    RRGGBB = true, -- #RRGGBB hex codes
                    names = false, -- 'Name' codes like Blue or blue
                    RRGGBBAA = false, -- #RRGGBBAA hex codes
                    AARRGGBB = false, -- 0xAARRGGBB hex codes
                    rgb_fn = false, -- CSS rgb() and rgba() functions
                    hsl_fn = false, -- CSS hsl() and hsla() functions
                    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = 'background', -- Set the display mode.
                    -- Available methods are false / true / 'normal' / 'lsp' / 'both'
                    -- True is same as normal
                    tailwind = false, -- Enable tailwind colors
                    -- parsers can contain values used in |user_default_options|
                    sass = { enable = false, parsers = { css }, }, -- Enable sass colors
                    virtualtext = '■',
                },
                -- all the sub-options of filetypes apply to buftypes
                buftypes = {},
            }
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            local function package_info_status()
                local status = require('package-info').get_status()
                if status == ' ' then
                    return ''
                end
                return status
            end

            local lualine = require('lualine')
            lualine.setup {
                options = {
                    theme = 'gruvbox-flat',
                    section_separators = {},
                    component_separators = '|',
                    icons_enabled = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { {'mode', upper = true} },
                    lualine_b = { {'branch', icon = ''}, { 'diff' } },
                    lualine_c = {
                        { 'filename', path = 1, file_status = true },
                        { 'diagnostics', sources = { 'nvim_diagnostic' } },
                        { 'aerial', sep = ' ❯ ' },
                        { package_info_status },
                        { function() return vim.fn['vm#themes#statusline']() end }
                    },
                    lualine_x = {
                        {
                            function()
                                local recording_register = vim.fn.reg_recording()
                                if recording_register == '' then
                                    return ''
                                end
                                return '@' .. recording_register
                            end
                        },
                        'encoding',
                        'fileformat',
                        'filetype'
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location'  },
                },
                extensions = { 'nvim-tree', 'toggleterm', 'aerial', 'man', 'quickfix' }
            }
        end
    }

    use {
        'romgrk/barbar.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('bufferline').setup {
                closable = false,
                letters = 'asdfjklöghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
            }
        end
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
                        hint = '',
                        info = '',
                        warning = '',
                        error = '',
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
                            { key = {'<CR>', 'o', '<2-LeftMouse>'}, cb = tree_cb('edit') },
                            { key = {'c', '<2-RightMouse>'},        cb = tree_cb('cd') },
                            { key = '<',                            cb = tree_cb('prev_sibling') },
                            { key = '>',                            cb = tree_cb('next_sibling') },
                            { key = 'P',                            cb = tree_cb('parent_node') },
                            { key = '<BS>',                         cb = tree_cb('close_node') },
                            { key = '<Tab>',                        cb = tree_cb('preview') },
                            { key = 'K',                            cb = tree_cb('first_sibling') },
                            { key = 'J',                            cb = tree_cb('last_sibling') },
                            { key = 'I',                            cb = tree_cb('toggle_git_ignored') },
                            { key = 'H',                            cb = tree_cb('toggle_dotfiles') },
                            { key = 'R',                            cb = tree_cb('refresh') },
                            { key = 'a',                            cb = tree_cb('create') },
                            { key = 'D',                            cb = tree_cb('remove') },
                            { key = 'r',                            cb = tree_cb('rename') },
                            { key = '<C-r>',                        cb = tree_cb('full_rename') },
                            { key = 'd',                            cb = tree_cb('cut') },
                            { key = 'y',                            cb = tree_cb('copy') },
                            { key = 'p',                            cb = tree_cb('paste') },
                            { key = 'Y',                            cb = tree_cb('copy_path') },
                            { key = 'gy',                           cb = tree_cb('copy_name') },
                            { key = '[c',                           cb = tree_cb('prev_git_item') },
                            { key = ']c',                           cb = tree_cb('next_git_item') },
                            { key = 'u',                            cb = tree_cb('dir_up') },
                            { key = 's',                            cb = tree_cb('system_open') },
                            { key = 'q',                            cb = tree_cb('close') },
                            { key = 'g?',                           cb = tree_cb('toggle_help') },
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
                shell = vim.env.SHELL or vim.opt.shell
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

    -- TODO: Replace with the 'splitkeep' option in neovim 0.9
    use {
        'luukvbaal/stabilize.nvim',
        config = function()
            require('stabilize').setup()
        end
    }

    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup {
                buftype_exclude = { 'terminal' },
                filetype_exclude = { 'alpha', 'packer', 'help', 'man', 'NvimTree', 'norg', 'aerial', 'noice' },
                space_char_blankline = ' ',
                show_current_context = true
            }
        end
    }

    use {
        'rcarriga/nvim-notify',
        config = function()
            local notify = require('notify')
            notify.setup {
                stages = 'fade',
            }
            ran_nvim_notify_setup = true
        end
    }

    -- FIXME: not working in neovide with multigrid: https://github.com/folke/noice.nvim/issues/17 https://github.com/neovim/neovim/pull/21080
    use {
        'folke/noice.nvim',
        tag = '*',
        requires = 'MunifTanjim/nui.nvim',
        config = function()
            require('noice').setup {
                cmdline = {
                    enabled = true,
                    view = 'cmdline',
                    opts = {}, -- global options for the cmdline. See section on views
                    ---@type table<string, CmdlineFormat>
                    format = {
                        cmdline = { pattern = '^:', icon = '', lang = 'vim' },
                        search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
                        search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
                        filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
                        lua = { pattern = '^:%s*lua%s+', icon = '', lang = 'lua' },
                        help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
                        input = {}, -- Used by input()
                    },
                },
                messages = {
                    enabled = true,
                    view = 'mini',
                    view_error = 'mini',
                    view_warn = 'mini',
                    view_history = 'messages',
                    view_search = 'virtualtext',
                },
                notify = {
                    enabled = true,
                    view = 'mini',
                },
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                        ['cmp.entry.get_documentation'] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false, -- add a border to hover docs and signature help
                },
                views = {
                    mini = {
                        timeout = 5000,
                    }
                },
            }
        end
    }

    use {
        'lewis6991/satellite.nvim',
        config = function()
            require('satellite').setup()
        end
    }

    -- Workaround for https://github.com/neovim/neovim/issues/12517
    use {
        'stevearc/stickybuf.nvim',
        config = function()
            require('stickybuf').setup{
                -- 'bufnr' will pin the exact buffer (PinBuffer)
                -- 'buftype' will pin the buffer type (PinBuftype)
                -- 'filetype' will pin the filetype (PinFiletype)
                buftype = {
                    ['']     = false,
                    acwrite  = false,
                    help     = 'buftype',
                    nofile   = false,
                    nowrite  = false,
                    quickfix = 'buftype',
                    terminal = false,
                    prompt   = 'bufnr',
                },
                wintype = {
                    autocmd  = false,
                    popup    = 'bufnr',
                    preview  = false,
                    command  = false,
                    ['']     = false,
                    unknown  = false,
                    floating = false,
                },
                filetype = {
                    aerial = 'filetype',
                    NvimTree = 'filetype',
                    toggleterm = 'filetype'
                },
                bufname = {
                    ['Neogit.*Popup'] = 'bufnr',
                },
                -- Some autocmds for plugins that need a bit more logic
                -- Set to `false` to disable the autocmd
                autocmds = {
                    -- Only pin defx if it was opened as a split (has fixed height/width)
                    defx = [[au FileType defx if &winfixwidth || &winfixheight | silent! PinFiletype | endif]],
                    -- Only pin fern if it was opened as a split (has fixed height/width)
                    fern = [[au FileType fern if &winfixwidth || &winfixheight | silent! PinFiletype | endif]],
                    -- Only pin neogit if it was opened as a split (there is more than one window)
                    neogit = [[au FileType NeogitStatus,NeogitLog,NeogitGitCommandHistory if winnr('$') > 1 | silent! PinFiletype | endif]],
                }
            }
        end
    }

    use {
        'smjonas/live-command.nvim',
        config = function()
            require('live-command').setup {
                commands = {
                    Normal = { cmd = 'normal' },
                },
            }
        end,
    }

    -- Navigation
    use 'christoomey/vim-tmux-navigator'

    use {
        'phaazon/hop.nvim',
        config = function()
            require('hop').setup {
                keys = 'asdghklöqwertyuiopzxcvbnmfjä'
            }
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
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    file_ignore_patterns = {
                        'node_modules'
                    },
                    preview = {
                        mime_hook = function(filepath, bufnr, opts)
                            local is_image = function(filepath)
                                local image_extensions = { 'png', 'jpg', 'gif' }   -- Supported image formats
                                local split_path = vim.split(filepath:lower(), '.', {plain=true})
                                local extension = split_path[#split_path]
                                return vim.tbl_contains(image_extensions, extension)
                            end

                            if is_image(filepath) and vim.fn.executable('catimg') == 1 then
                                local term = vim.api.nvim_open_term(bufnr, {})
                                local width = vim.api.nvim_win_get_width(opts.winid)
                                local height = vim.api.nvim_win_get_height(opts.winid)
                                local function send_output(_, data, _ )
                                    for _, d in ipairs(data) do
                                        vim.api.nvim_chan_send(term, d..'\r\n')
                                    end
                                end
                                vim.fn.jobstart({
                                    'catimg', '-w', width * 2, ' -H', height * 2, filepath
                                },
                                { on_stdout=send_output, stdout_buffered=true })
                            else
                                require('telescope.previewers.utils').set_preview_message(bufnr, opts.winid, 'Binary cannot be previewed')
                            end
                        end
                    }
                }
            }
        end
    }

    use {
        'nvim-telescope/telescope-project.nvim',
        requires = 'nvim-telescope/telescope.nvim',
        after = 'telescope.nvim',
        config = function()
            require('telescope').load_extension('project')
        end
    }

    use {
        'haya14busa/vim-asterisk',
        config = function()
            vim.keymap.set({'n', 'v'}, '*', '<Plug>(asterisk-*)')
            vim.keymap.set({'n', 'v'}, '#', '<Plug>(asterisk-#)')
            vim.keymap.set({'n', 'v'}, 'g*', '<Plug>(asterisk-g*)')
            vim.keymap.set({'n', 'v'}, 'g#', '<Plug>(asterisk-g#)')
        end
    }

    use {
        'mg979/vim-visual-multi',
        setup = function()
            vim.g.VM_set_statusline = 0
            vim.g.VM_silent_exit = 1
        end
    }

    -- Coding
    use {
        'neovim/nvim-lspconfig',
        tag = '*',
        requires = 'hrsh7th/cmp-nvim-lsp',
        config = function()
            local lspconfig = require('lspconfig')

            function on_lsp_attach()
                local clients = vim.lsp.get_active_clients()
                local bufnr = vim.api.nvim_get_current_buf()

                for _, client in ipairs(clients) do
                    if client.server_capabilities.goto_definition then
                        vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
                    end

                    if client.server_capabilities.document_formatting then
                        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
                    end
                end
            end

            local servers = { 'clangd', 'pyright', 'rust_analyzer', 'tsserver', 'bashls', 'texlab', 'svelte' }

            local server_config = {
                rust_analyzer = {
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            command = 'clippy',
                            --extraArgs = { '--offline' }
                        }
                    }
                },
                texlab = {
                    texlab = {
                        build = {
                            executable = 'pdflatex',
                            onSave = true
                        }
                    }
                }
            }

            for _, lsp in ipairs(servers) do
                local conf = {
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    on_attach = on_lsp_attach,
                    settings = server_config[lsp] or {}
                }
                if lsp == 'clangd' then
                    conf.cmd = { 'clangd', '--header-insertion=never' }

                    -- possible workaround for stuck diagnostics with clangd
                    conf.flags = {
                        allow_incremental_sync = false,
                        debounce_text_changes = 500
                    }
                end
                lspconfig[lsp].setup(conf)
            end

            local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

            for type, icon in pairs(signs) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
            end

            vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = true
            })
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        tag = '*',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                -- NOTE: comment parser is slow
                ensure_installed = { 'bash', 'c', 'c_sharp', 'cmake', 'cpp', 'css', 'cuda', 'dart', 'dockerfile', 'dot', 'fish', 'gdscript', 'glsl', 'go', 'gomod', 'help', 'hjson', 'html', 'java', 'javascript', 'jsdoc', 'json', 'json5', 'kotlin', 'latex', 'lua', 'make', 'markdown', 'markdown_inline', 'ninja', 'nix', 'php', 'pug', 'python', 'rasi', 'regex', 'rust', 'scss', 'svelte', 'toml', 'tsx', 'typescript', 'verilog', 'vim', 'vue', 'yaml' },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                    disable = { 'cpp' }
                },
            }

            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
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
        'RRethy/vim-illuminate',
        config = function()
            require('illuminate').configure {
                providers = {
                    'lsp',
                    'treesitter',
                },
                delay = 100,
            }

            vim.api.nvim_create_augroup('illuminate_augroup', { clear = true })
            vim.api.nvim_create_autocmd('VimEnter', {
                group = 'illuminate_augroup',
                callback = function()
                    vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'CursorLine', underline = false })
                    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'CursorLine', underline = false })
                    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'CursorLine', underline = false })
                end
            })
        end
    }

    use {
        'L3MON4D3/LuaSnip',
        run = "make install_jsregexp"
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
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            local luasnip = require('luasnip')

            local cmp = require('cmp')

            local lspkind = {
                Text = '',
                Method = '',
                Function = '',
                Constructor = '',
                Field = 'ﰠ',
                Variable = '',
                Class = 'ﴯ',
                Interface = '',
                Module = '',
                Property = 'ﰠ',
                Unit = '塞',
                Value = '',
                Enum = '',
                Keyword = '',
                Snippet = '',
                Color = '',
                File = '',
                Reference = '',
                Folder = '',
                EnumMember = '',
                Constant = '',
                Struct = 'פּ',
                Event = '',
                Operator = '',
                TypeParameter = '',
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
                    ['<Tab>'] = cmp.mapping(mapping_tab, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(mapping_shift_tab, { 'i', 's' }),
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
                        local ELLIPSIS_CHAR = '…'
                        local MAX_LABEL_WIDTH = 30

                        local label = vim_item.abbr
                        local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
                        if truncated_label ~= label then
                            vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
                        end

                        vim_item.kind = lspkind[vim_item.kind]
                        vim_item.menu = ({
                            calc = '[Calc]',
                            nvim_lsp = '[LSP]',
                            path = '[Path]',
                            luasnip = '[Snippet]',
                            latex_symbols = '[Latex]',
                            neorg = '[Neorg]',
                            buffer = '[Buffer]',
                        })[entry.source.name]
                        return vim_item
                    end
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.locality,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.score,
                        cmp.config.compare.offset,
                        cmp.config.compare.order,
                    },
                },
                experimental = {
                    ghost_text = true
                }
            })

            cmp.setup.cmdline('/', {
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = nil
                        vim_item.menu = nil
                        return vim_item
                    end
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(mapping_tab, { 'c' }),
                    ['<S-Tab>'] = cmp.mapping(mapping_shift_tab, { 'c' }),
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
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = nil
                        vim_item.menu = nil
                        return vim_item
                    end
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(mapping_tab, { 'c' }),
                    ['<S-Tab>'] = cmp.mapping(mapping_shift_tab, { 'c' }),
                },
                sources = {
                    { name = 'cmdline', keyword_pattern = [=[[^[:blank:w]]*]=] }
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
        'stevearc/aerial.nvim',
        config = function()
            require('aerial').setup {
                layout = {
                    placement = 'edge'
                },
                attach_mode = 'global',
                highlight_on_hover = true,
            }
        end
    }

    use {
        'TimUntersberger/neogit',
        requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
        cmd = 'Neogit',
        module = 'neogit',
        config = function()
            require('neogit').setup{
                integrations = {
                    diffview = true
                },
                disable_commit_confirmation = true -- Workaround for https://github.com/folke/noice.nvim/issues/232
            }
        end
    }

    use {
        'folke/trouble.nvim',
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
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
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
                    name = 'Launch file';

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = '${file}';
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
            require('dapui').setup {
                icons = { expanded = '▾', collapsed = '▸' },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { '<CR>', '<2-LeftMouse>' },
                    open = 'o',
                    remove = 'd',
                    edit = 'e',
                    repl = 'r',
                },
                layouts = {
                    {
                        elements = {
                            -- Elements can be strings or table with id and size keys.
                            { id = 'scopes', size = 0.25 },
                            'breakpoints',
                            'stacks',
                            'watches',
                        },
                        size = 40,
                        position = 'left',
                    },
                    {
                        elements = {
                            'repl',
                            'console',
                        },
                        size = 10,
                        position = 'bottom',
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    mappings = {
                        close = { 'q', '<Esc>' },
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
        'vuki656/package-info.nvim',
        tag = '*',
        requires = 'MunifTanjim/nui.nvim',
        config = function()
            require('package-info').setup()
        end
    }

    -- Languages
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

            vim.g.vimwiki_global_ext = 0
        end
    }

    use {
        'nvim-neorg/neorg',
        tag = '*',
        requires = 'nvim-lua/plenary.nvim',
        run = ':Neorg sync-parsers',
        after = 'nvim-treesitter',
        ft = 'norg',
        cmd = 'Neorg',
        config = function()
            require('neorg').setup {
                load = {
                    ['core.defaults'] = {},
                    ['core.norg.dirman'] = {
                        config = {
                            workspaces = {
                                home = '~/Documents/neorg',
                            },
                            autochdir = true,
                            index = 'index.norg',
                        }
                    },
                    ['core.norg.concealer'] = {
                        config = {
                        }
                    },
                    ['core.norg.completion'] = {
                        config = {
                            engine = 'nvim-cmp'
                        }
                    },
                    ['core.norg.qol.toc'] = {
                        config = {
                            toc_split_placement = 'left'
                        }
                    },
                    ['core.keybinds'] = {
                        config = {
                            default_keybinds = false,
                            hook = function(keybinds)
                                keybinds.remap_event('norg', 'n', '<cr>', 'core.norg.esupports.hop.hop-link')
                                keybinds.remap_event('toc-split', 'n', '<cr>', 'core.norg.qol.toc.hop-toc-link')
                                keybinds.remap_event('toc-split', 'n', 'q', 'core.norg.qol.toc.close')
                                keybinds.remap_event('toc-split', 'n', '<esc>', 'core.norg.qol.toc.close')
                            end,
                        }
                    }
                }
            }
        end,
    }

    use {
        'nvim-telescope/telescope-symbols.nvim',
        requires = 'nvim-telescope/telescope.nvim',
        after = 'telescope.nvim'
    }

    use {
        'ojroques/nvim-osc52',
        config = function()
            function copy()
                if vim.v.event.operator == 'y' and vim.v.event.regname == 'c' then
                    require('osc52').copy_register('c')
                end
            end

            vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
        end
    }

    use {
        'Darazaki/indent-o-matic',
        config = function()
            require('indent-o-matic').setup {
            max_lines = 2048,
            standard_widths = { 2, 4, 8 },
            filetype_bash = {
                -- workaround for a very strange bug where the indent seems to only be taken from line 19???
                skip_multiline = false
            }
        }
        end
    }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
                disable_filetype = { 'TelescopePrompt' , 'vim' },
                break_undo = false, -- Workaround for https://github.com/smjonas/live-command.nvim/issues/16
            }
        end
    }

    use {
        'folke/which-key.nvim',
        after = {
            'nvim-dap',
            'nvim-dap-ui',
            'hop.nvim',
            'gitsigns.nvim'
        },
        config = function()
            vim.g.mapleader = ' '

            local dap = require('dap')
            local dapui = require('dapui')
            local hop = require('hop')
            local gitsigns = require('gitsigns')

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

            -- tmux
            local tmux_prefix = '<c-q>'
            local tmux_keys = { name = 'tmux' }
            local tmux_key_assignment = {
                function()
                    vim.notify('This is not tmux')
                end,
                'tmux key'
            }
            for i = 0,9 do
                tmux_keys[tostring(i)] = tmux_key_assignment
            end
            -- FIXME: Add all keys
            for _, key in pairs({ 'c', 'x', 'z', '[', ']', '-', '|' }) do
                tmux_keys[key] = tmux_key_assignment
            end

            -- normal
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
                -- windows
                ['<c-+>'] = { '<cmd>resize +1<cr>', 'Increase window height' },
                ['<c-->'] = { '<cmd>resize -1<cr>', 'Decrease window height' },
                ['<c-s-<>'] = { '<cmd>vertical resize +1<cr>', 'Increase window width' },
                ['<c-<>'] = { '<cmd>vertical resize -1<cr>', 'Decrease window width' },
                -- Telescope
                ['<leader>f'] = {
                    name = 'Find',
                    f = { '<cmd>Telescope find_files<cr>', 'Find Files' },
                    l = { '<cmd>Telescope live_grep<cr>', 'Find Lines' },
                    b = { '<cmd>Telescope buffers<cr>', 'Find Buffers' },
                    h = { '<cmd>Telescope help_tags<cr>', 'Find Help' },
                    s = { function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 'Find LSP Symbols' },
                    S = { '<cmd>Telescope symbols<cr>', 'Find Symbols' },
                    p = { '<cmd>Telescope project<cr>', 'Find Projects' },
                    m = { function() require('telescope.builtin').man_pages({ sections = { '1', '2', '3', '4', '5', '6', '7', '8', '9' } }) end, 'Find Man Pages' },
                    r = { function() require('telescope.builtin').lsp_references({ jump_type = 'never' }) end, 'Find LSP References' },
                },
                -- LSP / Diagnostics
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
                    s = { '<cmd>AerialToggle<cr>', 'Toggle Symbols Outline' },
                    g = { function() require('neogit').open({ kind = 'split' }) end, 'Neogit' },
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
                -- open
                ['<leader>o'] = {
                    name = 'Open',
                    t = { function() vim.cmd('terminal ' .. (vim.env.SHELL or vim.opt.shell)) end, 'Open terminal' }
                },
                ['<F5>'] = { dap.continue, 'Continue' },
                ['<F10>'] = { dap.step_over, 'Step over' },
                ['<F11>'] = { dap.step_into, 'Step into' },
                ['<F12>'] = { dap.step_out, 'Step out' },
                -- hop
                ['s'] = { hop.hint_words, 'Hop word' },
                ['S'] = { function() hop.hint_words({ multi_windows = true }) end, 'Hop word Multi Window' },
                -- move line
                ['<m-c-k>'] = { ':m -2<cr>==', 'Move line up' },
                ['<m-c-j>'] = { ':m +1<cr>==', 'Move line down' },
                -- start neorg
                ['<leader>n'] = { ':Neorg workspace home<cr>', 'Start Neorg' },
                -- tmux
                [tmux_prefix] = tmux_keys,
                -- git
                ['[h'] = { gitsigns.prev_hunk, 'Previous git hunk' },
                [']h'] = { gitsigns.next_hunk, 'Next git hunk' },
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

            -- visual
            wk.register({
                -- move line
                ['<m-c-k>'] = { ':m \'<-2<cr>gv=gv', 'Move lines up' },
                ['<m-c-j>'] = { ':m \'>+1<cr>gv=gv', 'Move lines up' },
                -- osc52
                ['<leader>y'] = { function() require('osc52').copy_visual() end, 'osc52 Yank' },
                -- hop
                ['s'] = { hop.hint_words, 'Hop word' },
                ['S'] = { function() hop.hint_words({ multi_windows = true }) end, 'Hop word Multi Window' },
                -- Other
                ['<'] = { '<gv', 'Unindent' },
                ['>'] = { '>gv', 'Indent' },
                ['ö'] = { '[', '', noremap = false },
                ['ä'] = { ']', '', noremap = false },
                ['öö'] = { '[[', '' },
                ['ää'] = { ']]', '' },
                ['Ö'] = { '{', '', noremap = false },
                ['Ä'] = { '}', '', noremap = false },
                ['n'] = { ':Normal ', 'Execute normal mode command on lines', silent = false }
            }, { mode = 'v' })

            -- terminal
            wk.register({
                ['<esc><esc>'] = { '<c-bslash><c-n>', 'Exit Terminal Mode' },
                ['<c-h>'] = { '<c-bslash><c-n><cmd>TmuxNavigateLeft<cr>', 'Window Left' },
                ['<c-j>'] = { '<c-bslash><c-n><cmd>TmuxNavigateDown<cr>', 'Window Down' },
                ['<c-k>'] = { '<c-bslash><c-n><cmd>TmuxNavigateUp<cr>', 'Window Up' },
                ['<c-l>'] = { '<c-bslash><c-n><cmd>TmuxNavigateRight<cr>', 'Window Right' },
                ['<m-k>'] = { function() if vim.bo.buflisted then vim.cmd'BufferPrevious' end end, 'Previous Buffer' },
                ['<m-j>'] = { function() if vim.bo.buflisted then vim.cmd'BufferNext' end end, 'Next Buffer' },
                ['<m-q>'] = { function() if vim.bo.buflisted then vim.cmd'BufferClose!' else vim.cmd'bd!' end end, 'Close Buffer' },
                ['<m-Q>'] = { function() if vim.bo.buflisted then vim.cmd'BufferClose!' else vim.cmd'bd!' end end, 'Close Buffer' },
            }, { mode = 't' })

            -- cmdline
            wk.register({
                ['<c-h>'] = { '<Left>', 'Cursor left' },
                ['<c-l>'] = { '<Right>', 'Cursor right' },
                ['<c-k>'] = { '<Up>', 'Recall older command-line from history' },
                ['<c-j>'] = { '<Down>', 'Recall more recent command-line from history' },
                ['<c-b>'] = { '<C-Left>', 'Previous WORD' },
                ['<c-w>'] = { '<C-Right><Right>', 'Next WORD' },
                ['<c-e>'] = { '<Right><C-Right><Left>', 'End of next WORD' },
            }, { mode = 'c', silent = false })
        end
    }
end)

--- -----------------------
---        AUTOCMDS
--- -----------------------

function notify_until_success(message, log_level, options)
    local max_tries = 10
    local notification_timer = vim.loop.new_timer()
    local counter = 0

    notification_timer:start(0, 500, function()
        counter = counter + 1
        if (ran_nvim_notify_setup or counter >= max_tries) then
            require('notify')(message, log_level, options)
            notification_timer:close()
        end
    end)
end

-- automatically call PackerCompile if init.lua was edited
local config_file = vim.fn.stdpath('config')..'/init.lua'
local compile_file = vim.fn.stdpath('config')..'/plugin/packer_compiled.lua'
if (vim.fn.filereadable(config_file) and vim.fn.filereadable(compile_file) and vim.fn.getftime(config_file) > vim.fn.getftime(compile_file))
then
    if (vim.fn.hostname() == 'Rotkehlchen')
    then
        require('packer').install()
        require('packer').compile()

        notify_until_success('Config reloaded', vim.log.levels.INFO, {
            title = 'Configuration File'
        })
    else
        notify_until_success('Run :PackerSync and restart neovim to apply changes to the config file.', vim.log.levels.WARN, {
            title = 'Configuration File', timeout = false
        })
    end
end

--- Remove trailing spaces
vim.cmd [[autocmd BufWritePre * %s/\s\+$//e]]

--- Enter insert mode when navigating to a terminal
vim.cmd [[autocmd BufWinEnter,WinEnter term://* startinsert]]

--- Format code on save
vim.api.nvim_create_augroup('fmt', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'fmt',
    callback = function()
        -- FIXME: This is a bad solution, but sync format seems to cause the lsp server to crash. Or does it? What?
        if vim.bo.filetype == 'cpp' and vim.fn.filereadable('.clang-format') == 1 then
            vim.lsp.buf.format({ timeout_ms = 2000 })
        elseif vim.bo.filetype == 'rust' then
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end
    end
})

--- Highlightedjank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'),
            timeout=200
        }
    end
})

--- -----------------------
---        FILETYPES
--- -----------------------

vim.filetype.add({
    pattern = {
        ['.*'] = {
            priority = -math.huge,
            function(path, bufnr)
                local content = vim.filetype.getlines(bufnr, 1)
                if vim.filetype.matchregex(content, [[#!.*fish]]) then
                    return 'fish'
                elseif vim.filetype.matchregex(content, [[#!.*bash]]) then
                    return 'bash'
                end
            end
        }
    }
})

--- -----------------------
---     CONFIGURATION
--- -----------------------
-- basics
vim.opt.compatible = false
vim.opt.hidden = true

-- visual
vim.opt.background = 'dark'
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.opt.cmdheight = 0
vim.opt.conceallevel = 1
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:+'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showbreak = '↪ '
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.title = true

-- split
vim.opt.eadirection = 'hor'
vim.opt.equalalways = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- spelling
vim.opt.spelllang = { 'en', 'de' }

-- folding
vim.opt.foldlevel = 99

-- code style
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'

-- Gui settings
vim.opt.guifont = 'JetbrainsMono Nerd Font:h10'
vim.g.neovide_remember_window_size = false

-- other
vim.opt.inccommand = 'nosplit'
vim.opt.scrolloff = 1
vim.opt.switchbuf:append('useopen')
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.virtualedit = 'block'
vim.opt.shell = '/bin/sh' -- Fix performance issues with nvim-tree.lua and potentially some other bugs

--- -----------------------
---     COMMANDS
--- -----------------------

function Sort()
    -- TODO: Support bang to reverse sort
    -- TODO: Respect end pos
    -- TODO: Handle unset mark
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    vim.cmd(string.format("'<,'>sort /.\\{%s\\}/", start_pos[2]))
end

vim.cmd[[command! -range=% -bang Sort lua Sort()]]

-- Workaround for https://github.com/neovim/neovim/issues/19649 taken from https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
local function getlines(location)
    local uri = location.targetUri or location.uri
    if uri == nil then
        return
    end
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end
    local range = location.targetRange or location.range

    local lines = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range['end'].line+1, false)
    return table.concat(lines, '\n')
end

vim.diagnostic.config({float = {format = function(diag)
    local message = diag.message
    local client = vim.lsp.get_active_clients({name = message.source})[1]
    if not client then
        return diag.message
    end

    local relatedInfo = {messages = {}, locations = {}}
    if diag.user_data.lsp.relatedInformation ~= nil then
        for _, info in ipairs(diag.user_data.lsp.relatedInformation) do
            table.insert(relatedInfo.messages, info.message)
            table.insert(relatedInfo.locations, info.location)
        end
    end

    for i, loc in ipairs(vim.lsp.util.locations_to_items(relatedInfo.locations, client.offset_encoding)) do
        message = string.format('%s\n%s (%s:%d):\n\t%s', message, relatedInfo.messages[i],
            vim.fn.fnamemodify(loc.filename, ':.'), loc.lnum,
            getlines(relatedInfo.locations[i]))
    end

    return message
end}})
-- Workaround end
