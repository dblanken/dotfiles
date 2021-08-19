local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section

local function file_readonly(readonly_icon)
  if vim.bo.filetype == 'help' then
    return ''
  end
  local icon = readonly_icon or ''
  if vim.bo.readonly == true then
    return " " .. icon .. " "
  end
  return ''
end
local get_current_file_path = function(modified_icon, readonly_icon)
  local filepath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.')
  if vim.fn.empty(filepath) == 1 then return '' end

  if string.len(file_readonly(readonly_icon)) ~= 0 then
    return filepath .. file_readonly(readonly_icon)
  end
  local icon = modified_icon or ''
  if vim.bo.modifiable then
    if vim.bo.modified then
      return filepath .. ' ' .. icon .. '  '
    end
  end
  return filepath .. ' '
end

-- Colors for Gruvbox
local colors_gruvbox = {
  bg = '#282828',
  fg = '#fbf1c7',
  yellow = '#fabd2f',
  cyan = '#83a598',
  darkblue = '#458588',
  green = '#98971a',
  orange = '#fe8019',
  violet = '#b16286',
  magenta = '#d3869b',
  blue = '#83a598',
  red = '#cc241d',
}

local colors = colors_gruvbox
colors.bg = colors.none

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {n = colors.red, i = colors.green,v=colors.blue,
      [''] = colors.blue,V=colors.blue,
      c = colors.magenta,no = colors.red,s = colors.orange,
      S=colors.orange,[''] = colors.orange,
      ic = colors.yellow,R = colors.violet,Rv = colors.violet,
      cv = colors.red,ce=colors.red, r = colors.cyan,
      rm = colors.cyan, ['r?'] = colors.cyan,
      ['!']  = colors.red,t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = {colors.red,colors.bg,'bold'},
  },
}

gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
}

gls.left[5] = {
  FilePath = {
    provider = get_current_file_path,
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'}
  }
}

gls.left[6] = {
  BuFferType = {
    provider = function()
      local filetype = vim.bo.filetype:upper()
      if filetype == '' then
        filetype = 'UNKNOWN'
      end
      return string.format("[%s]", filetype)
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

gls.right[1] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    separator = ' ',
    highlight = {colors.red,colors.bg}
  }
}
gls.right[2] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    separator = ' ',
    highlight = {colors.yellow,colors.bg},
  }
}

gls.right[3] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    separator = ' ',
    highlight = {colors.cyan,colors.bg},
  }
}

gls.right[4] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    separator = ' ',
    highlight = {colors.blue,colors.bg},
  }
}

gls.right[5] = {
  LineInfo = {
    provider = function()
      local line = vim.fn.line('.')
      local column = vim.fn.col('.')
      -- (Literal, \u2113 "SCRIPT SMALL L").
      -- (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
      return string.format("ℓ %3d / 𝚌 %2d ", line, column)
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.right[6] = {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = function ()
      local tbl = {['dashboard'] = true,['']=true}
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    icon = ' ',
    separator = '     ',
    highlight = {colors.cyan,colors.bg,'bold'}
  }
}

gls.right[7] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[8] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[9] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}
gls.right[10] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}
gls.right[11] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}
