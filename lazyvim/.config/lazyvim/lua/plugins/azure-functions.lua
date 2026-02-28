return {
  "kaiwalter/azure-functions.nvim",
  config = function()
    require("azure-functions").setup({
      compress_log = true,
    })
  end,
}
