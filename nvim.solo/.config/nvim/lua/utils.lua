local root = vim.env.USER == 'root'

--we can load shada now
if not vim.env.USER == 'root' then
  vim.opt.shadafile = ""
end
