-- Plugin: conform.nvim
-- Description: Lightweight yet powerful formatter
-- Source: LazyVim
--
-- Set to false to disable this plugin
local enabled = true

if not enabled then
  return {}
end

return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        -- User override: Drupal PHP formatting
        php = { "phpcbf" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- User override: Drupal-specific PHP code beautifier
        phpcbf = {
          prepend_args = { "--standard=Drupal,DrupalPractice", "--extensions=php,module,inc,install,test,profile,theme,info,txt" },
        },
      },
    }
    return opts
  end,
}
