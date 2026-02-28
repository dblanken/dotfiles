-- Plugin: nvim-ts-autotag
-- Description: Automatically add closing tags for HTML and JSX
-- Source: LazyVim
--
-- Set to false to disable this plugin
local enabled = true

if not enabled then
  return {}
end

return {
  "windwp/nvim-ts-autotag",
  event = "VeryLazy",
  opts = {},
}
