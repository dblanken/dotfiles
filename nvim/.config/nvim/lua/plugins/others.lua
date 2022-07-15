local M = {}

M.luasnip = function()
   local present, luasnip = pcall(require, "luasnip")
   if not present then
      return
   end

   luasnip.config.set_config {
      history = true,
      updateevents = "TextChanged,TextChangedI",
   }
   require("luasnip/loaders/from_vscode").load()
end

M.comment = function()
   local present, comment = pcall(require, "Commment")
   if present then
      comment.setup {
         padding = true,
      }
   end
end

return M
