local present1, autopairs = pcall(require, "nvim-autopairs")
local present2, autopairs_completion = pcall(require, "nvim-autopairs.completion.compe")

if not (present1 or present2) then
    return
end

autopairs.setup()
autopairs_completion.setup(
    {
        map_cr = true,
        map_complete = true, -- insert () func completion
        auto_select = false
    }
)
autopairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
