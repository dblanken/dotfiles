return {
  "stevearc/conform.nvim",
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      formatters_by_ft = {
        php = {"phpcbf"},
      },
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        phpcbf = {
          prepend_args = { "--standard=Drupal,DrupalPractice", "--extensions=php,module,inc,install,test,profile,theme,info,txt" },
        },
      },
    }
    return opts
  end,
}
