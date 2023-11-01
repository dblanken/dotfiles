return {                                                   -- better highlighting and more
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'lua', 'python', 'tsx', 'typescript', 'vimdoc', 'vim', 'ruby', 'php', 'twig', 'css', 'html', 'javascript' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  }
