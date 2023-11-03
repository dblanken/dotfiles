-- return { 'github/copilot.vim' }

return {
  'zbirenbaum/copilot.lua',
  commit = '1a8032ae496916ccc7a7a52ee79194fbef29f462',
  config = function()
    -- vim.lsp.set_log_level('debug')
    require('copilot').setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
}
