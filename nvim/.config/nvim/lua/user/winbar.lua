local M = {}

local status_gps_ok, gps = pcall(require, "nvim-gps")
if not status_gps_ok then
  return
end

local get_filename = function()
  return vim.fn.expand "%:t"
end

local get_gps = function()
  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then
    return ""
  end

  if not gps.is_available() then -- Returns boolean value indicating whether a output can be provided
    return ""
  end

  if gps_location == "error" then
    return ""
  else
    if not (gps_location == nil or gps_location == "") then
      return " > " .. gps_location
    else
      return ""
    end
  end
end

local excludes = function()
  local winbar_filetype_exclude = {
    "help",
    "packer",
    "NvimTree",
  }

  if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end

  return false
end

M.get_winbar = function()
  if excludes() then
    return
  end
  local value = get_filename()

  if not (value == nil or value == "") then
    local gps_value = get_gps()
    value = value .. " " .. gps_value
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

return M
