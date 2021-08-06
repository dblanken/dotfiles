vim.cmd [[
augroup spelling
  autocmd!
  autocmd FileType git,text,markdown,pandoc setlocal spell
augroup END
]]
