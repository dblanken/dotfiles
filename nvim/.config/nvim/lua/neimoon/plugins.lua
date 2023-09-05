local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'folke/lazy.nvim' },
  {                                                 -- Fallback Colorscheme
    'rose-pine/neovim',
    as = 'rose-pine',
  },
  {                                                 -- Fuzzy finding
    'nvim-telescope/telescope.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    cmd = {
      "Telescope",
    },
    keys = {
      { '<leader>?', function() require('telescope.builtin').oldfiles() end, desc = '[?] Find recently opened files' },
      { '<leader><space>', function() require('telescope.builtin').buffers() end, desc = '[ ] Find existing buffers' },
      { '<Leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, desc = '[/] Fuzzily search in the current buffer' },
      { '<Leader>sf', function() require('telescope.builtin').find_files({ hidden = true }) end, desc = '[S]earch [F]iles' },
      { '<Leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
    },
  },
  {                                                 -- lsp/completion/snippets
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { 'hrsh7th/cmp-buffer' },       -- Optional
      { 'hrsh7th/cmp-path' },         -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' },     -- Optional

      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          { 'rafamadriz/friendly-snippets' },
        },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      },             -- Required
    },
    config = function()
      local lsp = require('lsp-zero').preset({
        name = 'recommended',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = true,
      })

      lsp.ensure_installed({
        'lua_ls',
        'tsserver',
        'eslint',
        'intelephense',
      })

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})

        if client.name == 'intelephense' then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F3>', '<cmd>ALEFix<cr>', {noremap = true, silent = true})
        end

        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, bufnr)
        end
      end)

      local cmp = require('cmp')
      local cmp_select = {behavior = cmp.SelectBehavior.Select}
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
      })

      -- Helps with copilot
      cmp_mappings['<Tab>'] = nil
      cmp_mappings['<S-Tab>'] = nil

      local cmp_sources = {
        {name = 'copilot'},
        {name = 'nvim_lua'},
      }
      -- Get lsp-zero's default sources
      local lsp_sources = lsp.defaults.cmp_sources()
      --append to cmp_sources
      for _, source in ipairs(lsp_sources) do
        table.insert(cmp_sources, source)
      end


      lsp.setup_nvim_cmp({
        mapping = cmp_mappings,
        sources = cmp_sources,
      })

      -- Intelephense like to create a directory on my home directory
      -- I don't like this.
      require('lspconfig').intelephense.setup {
        init_options = {
          globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
        },
        config = {
          ["intelephense.environment.includePaths"] = {
            "web/core/includes"
          },
          ["intelephense.files.associations"] = {
            "*.inc",
            "*.theme",
            "*.install",
            "*.module",
            "*.profile",
            "*.php",
            "*.phtml"
          },
        },
      }

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

    end
  },
  {                                                   -- diagnostics in quickfix
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = true,
      }
    end,
  },
  {                                                   -- better highlighting and more
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'lua', 'python', 'tsx', 'typescript', 'vimdoc', 'vim', 'ruby', 'php', 'twig', 'css', 'html' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end
  },
  { 'nvim-treesitter/nvim-treesitter-context' },      -- better contexts
  {
    'tpope/vim-fugitive',
    keys = {
      { 'gh', '<cmd>diffget //2<CR>' },
      { 'gk', '<cmd>diffget //3<CR>' },
      { '<Leader>gs', vim.cmd.Git },
    },
    cmd = {
      "Git",
      "G",
    },
    config = function()
      local dblanken_fugitive = vim.api.nvim_create_augroup("dblanken_fugitive", {})

      local autocmd = vim.api.nvim_create_autocmd
      autocmd("BufWinEnter", {
        group = dblanken_fugitive,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local opts = {buffer = bufnr, remap = false}

          -- Push
          vim.keymap.set("n", "<leader>p", function()
            vim.cmd [[ Git push ]]
          end, opts)

          -- Pull with rebase
          vim.keymap.set("n", "<leader>P", function()
            vim.cmd [[ Git pull --rebase ]]
          end, opts)

          -- Easy branch pushing
          vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
        end,
      })
    end
  },
  { 'tpope/vim-commentary' },                         -- commenting
  {                                                   -- easy traversal
    'tpope/vim-projectionist',
    config = function()
      vim.g.projectionist_heuristics = {
        ["&pantheon.yml"] = {
          ["*"] = { ["dispatch"] = "lando drush cr" }
        },
        ["&atomic.info.yml"] = {
          ["*"] = { ["dispatch"] = "lando drush cr" },
          ["templates/*.html.twig"] = {
            ["type"] = "template",
          },
        },
        ["webpack/webpack.common.js"] = {
          ["*"] = { ["dispatch"] = "npm run build" },
          ["components/*.twig"] = {
            ["type"] = "components",
          },
          ["components/*.scss"] = {
            ["type"] = "scss",
          },
          ["components/*.js"] = {
            ["type"] = "js",
          },
          ["components/*.yml"] = {
            ["type"] = "yml"
          },
        },
      }
    end
  },
  { 'tpope/vim-dispatch' },                           -- async "make"
  { 'tpope/vim-sleuth' },                             -- tabstops based on files around it
  { 'tpope/vim-unimpaired' },                         -- [] commands
  { 'tpope/vim-eunuch' },                             -- Unix cmds in vim
  { 'tpope/vim-repeat' },                             -- . command plugin repeat
  { 'tpope/vim-vinegar' },                            -- '-' for netrw
  { 'tpope/vim-apathy' },                             -- find paths automagically
  { 'tpope/vim-abolish' },                            -- Fix/substitution
  { 'tribela/vim-transparent' },                      -- Make vim transparent
  {
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_key_mappings = {
        table_mappings = 0,
      }
      vim.g.vimwiki_list = {
        {
          path = '~/.vimwiki',
          syntax = 'markdown',
          ext = '.md'
        },
        {
          path = '~/Documents/vimwiki',
          syntax = 'markdown',
          ext = '.md'
        }
      }

      -- Reload variables since vimwiki needs it before it loads usually
      vim.fn['vimwiki#vars#init']()
    end
  },                              -- Notes
  {                                                   -- vim-tmux-navigator
    'numToStr/Navigator.nvim',
    config = true,
    keys = {
      {
        mode = { "n", "t" },
        "<C-h>",
        "<CMD>NavigatorLeft<CR>",
        desc = "Navigate left",
      },
      {
        mode = { "n", "t" },
        "<C-l>",
        "<CMD>NavigatorRight<CR>",
        desc = "Navigate right",
      },
      {
        mode = { "n", "t" },
        "<C-k>",
        "<CMD>NavigatorUp<CR>",
        desc = "Navigate up",
      },
      {
        mode = { "n", "t" },
        "<C-j>",
        "<CMD>NavigatorDown<CR>",
        desc = "Navigate down",
      },
    },
  },
  {
    'vim-test/vim-test',
    keys = {
      { '<Leader>t', '<cmd>:TestNearest<CR>' },
      { '<Leader>T', '<cmd>:TestFile<CR>' },
      { '<Leader>a', '<cmd>:TestSuite<CR>' },
      { '<Leader>l', '<cmd>:TestLast<CR>' },
    },
    config = function()
      vim.g["test#strategy"] = 'dispatch'

      -- Don't run over and over; run once and allow me to test a different area the next time
      vim.g["test#javascript#reactscripts#executable"] = "node_modules/.bin/react-scripts test --watchAll=false"
    end
  },                              -- Easier testing
  {                                                     -- colorize hex colors
    'norcalli/nvim-colorizer.lua',
    main = 'colorizer',
    config = function()
      require('colorizer').setup({
        '*';
      }, { css = true })
    end,
  },
  {
    'mfussenegger/nvim-dap',                            -- Debug protocol
    dependencies = {
      {
          'rcarriga/nvim-dap-ui',
          keys = {
              { "<Leader>de", function() require('dapui').eval() end, desc = "Evaluate" },
              { "<leader>dE", function() require('dapui').eval(vim.fn.input "[DAP] Expression > ") end, desc = "Evaluate with expression" },
          },
          config = function()
              local dap = require('dap')
              local dapui = require('dapui')

              dap.listeners.after.event_initialized["dapui_config"] = function()
                  require('dapui').open()
              end

              dap.listeners.before.event_terminated["dapui_config"] = function()
                  require('dapui').close()
              end

              dap.listeners.before.event_exited["dapui_config"] = function()
                  require('dapui').close()
              end
          end
      },                       -- UI for dap
      { 'theHamsta/nvim-dap-virtual-text' },            -- Virtual text for dap
      { 'nvim-telescope/telescope-dap.nvim' },          -- Telescope dap
      {
        'jay-babu/mason-nvim-dap.nvim',
        opts = {
          automatic_installation = true,

          handlers = {},

          ensure_installed = {
            'node2',
            'chrome',
            'firefox',
            'php',
            'js',
            'bash',
          },
        }
      },
    },
    cmd = {
      'DapContinue',
      'DapInstall',
      'DapUninstall',
    },
    keys = {
      { '<F11>', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<F10>', function() require('dap').step_over() end, desc = 'Step Over' },
      { '<F12>', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<F5>', function() require('dap').continue() end, desc = 'Continue' },
      { '<Leader>dr', function() require('dap').repl.open() end, desc = 'Open REPL' },
      { '<Leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<Leader>B', function() require('dap').set_breakpoint(vim.fn.input '[DAP] Condition > ') end, desc = "Breakpoint with Condition" },
    },
    config = function()
      require('dapui').setup()

      local dap = require('dap')
      local dap_languages = { 'php', 'twig' }

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/code/vscode-php-debug/out/phpDebug.js" }
      }

      for _, language in ipairs(dap_languages) do
        dap.configurations[language] = {
          {
            type = "php",
            request = "launch",
            name = "Listen for Xdebug",
            port = 9003,
            pathMappings = {
              ["/app/"] = "${workspaceFolder}"
            },
          }
        }
      end
    end
  },
  {                                                     -- See markdown while editing
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end
  },
  { 'mxsdev/nvim-dap-vscode-js' },                      -- dap adapter for vscode-js-debug
  {                                                     -- vscode-js-debug
    'microsoft/vscode-js-debug',
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {                                                     -- lua copilot
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        suggestion = {enabled = false},
        panel = {enabled = false},
      })
    end
  },
  {                                                     -- copilot for cmp
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'RRethy/nvim-base16',
    config = function()
      vim.cmd('colorscheme base16-' .. vim.env["BASE16_THEME"])
    end
  },
  {
    'fgheng/winbar.nvim',
    config = function()
      require('winbar').setup({
        enabled = true,

        show_file_path = true,
        show_symbols = true,

        colors = {
          path = '', -- You can customize colors like #c946fd
          file_name = '',
          symbols = '',
        },

        icons = {
          file_icon_default = '',
          seperator = '>',
          editor_state = '●',
          lock_icon = '',
        },

        exclude_filetype = {
          'help',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'alpha',
          'lir',
          'Outline',
          'spectre_panel',
          'toggleterm',
          'qf',
        }
      })
    end
  },
  {
    'SmiteshP/nvim-navic',
    config = function()
      local navic = require('nvim-navic')

      require('lualine').setup({
        options = { theme = 'base16' },
        winbar = {
          lualine_c = {
            "navic",
            color_correction = nil,
            navic_opts = nil
          }
        }
      })
    end
  },
  {
    'Wansmer/treesj',
    keys = {
      {
        "<Leader>sj",
        "<CMD>TSJToggle<CR>",
        desc = "Toggle Treesitter Join",
      }
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    "f-person/git-blame.nvim",
    keys = {
      {
        "<Leader>gb",
        "<CMD>GitBlameToggle<CR>",
        desc = "Toggle Git Blame",
      },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    main = "nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").register_progress()
    end,
  },
  {
    "jamestthompson3/nvim-remote-containers"
  },
  {
    "jay-babu/mason-nvim-dap.nvim"
  },
  {
    'dense-analysis/ale',
    config = function()
      vim.g.ale_disable_lsp = 1
      vim.g.ale_echo_msg_format = '[%linter%] %code: %%s'
      vim.g.ale_use_neovim_diagnostics_api = 1

      vim.g.ale_php_phpcs_standard = 'Drupal,DrupalPractice'
      vim.g.ale_php_phpcs_options = '--extensions=php,module,inc,install,test,profile,theme,info,txt'

      vim.g.ale_php_phpcbf_standard = 'Drupal,DrupalPractice'
      vim.g.ale_php_phpcbf_options = '--extensions=php,module,inc,install,test,profile,theme,info,txt'

      vim.g.ale_linters_explicit = 1
      vim.g.ale_linters = {
        php = {
          'phpcs'
        }
      }

      vim.g.ale_fixers = {
        ['*'] = {
          'remove_trailing_lines',
          'trim_whitespace'
        },
        php = {
          'phpcbf'
        },
        twig = {
          'twigcs'
        },
      }
    end
  },
}, {
    lazy = true,
  })
