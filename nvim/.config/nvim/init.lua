require('first_load')

local dblanken_modules = {
  "options",
  "globals",
  "mappings",
  "autocmds",
  "utils",
}

for i = 1, #dblanken_modules, 1 do
  pcall(require, dblanken_modules[i])
end
