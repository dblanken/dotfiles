local my_modules = {
  "options",
  "mappings",
  "utils"
}

for i = 1, #my_modules, 1 do
  pcall(require, my_modules[i])
end
