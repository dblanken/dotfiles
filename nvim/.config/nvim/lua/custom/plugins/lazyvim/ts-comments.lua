-- Plugin: ts-comments.nvim
-- Description: Improves comment syntax for multiple comment types per language
-- Source: LazyVim
--
-- Set to false to disable this plugin
local enabled = true

if not enabled then
  return {}
end

return {
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
}
