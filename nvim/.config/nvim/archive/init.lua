vim.g.mapleader = " "

local modules_to_load = {
    'disable_builtin',
    'globals',
    'options',
    'netrw',
    'mappings',
    'grep',
    'highlight',

    'plugins.colorschemes.dracula'
}

for i = 1, #modules_to_load, 1 do
    ---@diagnostic disable-next-line: unused-local
    local ok, _loaded = pcall(require, modules_to_load[i])
    if not ok then
        print("Could not load " .. modules_to_load[i])
    end
end
