-- Plugin: lazydev.nvim
-- Description: Configures LuaLS for Neovim configuration editing
-- Source: LazyVim
--
-- Set to false to disable this plugin
local enabled = true

if not enabled then
  return {}
end

return {
  "folke/lazydev.nvim",
  ft = "lua",
  cmd = "LazyDev",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
    },
  },
}
