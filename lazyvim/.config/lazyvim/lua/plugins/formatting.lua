return {
  "stevearc/conform.nvim",
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        phpcbf = {
          args = function(_, ctx)
            return {
              "--standard=Drupal",
              "--extensions=php,module,inc,install,test,profile,theme,info,txt",
              "$FILENAME",
            }
          end,
        },
      },
    }
    return opts
  end,
}
