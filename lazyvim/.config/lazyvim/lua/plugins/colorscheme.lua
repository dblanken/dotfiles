local function get_tokyonight_style()
  local os_name = vim.loop.os_uname().sysname

  if os_name == "Darwin" then
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if handle then
      local result = handle:read("*a"):gsub("%s+", "")
      handle:close()

      if result == "Dark" then
        return "night"
      else
        return "day"
      end
    else
      return "day"
    end
  end

  return "night"
end

local function toggle_style()
  if vim.g.colors_name == "tokyonight-day" then
    vim.cmd("colorscheme tokyonight-night")
  else
    vim.cmd("colorscheme tokyonight-day")
  end
end

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = get_tokyonight_style(),
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")

      vim.api.nvim_create_user_command("ToggleStyle", toggle_style, {
        desc = "Toggle between day and night TokyoNight styles"
      })
    end,
  },
}
