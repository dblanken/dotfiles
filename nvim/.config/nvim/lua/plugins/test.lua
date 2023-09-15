return {
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
  }
