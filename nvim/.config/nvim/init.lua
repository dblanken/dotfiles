local my_modules = {
  "options",
  "mappings",
  "utils"
}

LSPS = { builtin = 1, coc = 2 }

CurrentLSP = LSPS["builtin"]

for i = 1, #my_modules, 1 do
  pcall(require, my_modules[i])
end
