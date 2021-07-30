local lsp_icon = vim.g.lsp_icon or 'lsp='

-- Get the name of the main client used in the buffer
-- to show in the status line
function LspStatus()
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    return lsp_icon .. vim.lsp.buf_get_clients(0)[1].name
  else
    return ''
  end
end

-- Get the diagnostics to show on status line
function LspDiagnostics()
  local signs = require('guttersigns').signs
  local sl = ''
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
    sl = sl .. signs.Error
    sl = sl .. ' ' .. vim.lsp.diagnostic.get_count(0, [[Error]])
    sl = sl .. ' ' .. signs.Warning
    sl = sl .. ' ' .. vim.lsp.diagnostic.get_count(0, [[Warning]])
    sl = sl .. ' ' .. signs.Information
    sl = sl .. ' ' .. vim.lsp.diagnostic.get_count(0, [[Information]])
    sl = sl .. ' ' .. signs.Hint
    sl = sl .. ' ' .. vim.lsp.diagnostic.get_count(0, [[Hint]])

    return sl
  else
    return ''
  end
end

vim.cmd [[
function! LspStatus() abort
  return luaeval('LspStatus()')
endfunction

function! LspDiagnostics() abort
  return luaeval('LspDiagnostics()')
endfunction

augroup flagships
  autocmd!
  autocmd User Flags call Hoist('buffer', 'LspStatus')
  autocmd User Flags call Hoist('buffer', 'LspDiagnostics')
  autocmd User LspDiagnosticsChanged packadd vim-flagship <bar> doautocmd <nomodeline> User Flags
augroup END
]]


