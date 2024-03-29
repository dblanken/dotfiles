return {
  "arnaud-lb/vim-php-namespace",
  config = function()
    vim.cmd [[
      function! IPhpInsertUse()
        call PhpInsertUse()
        call feedkeys('a',  'n')
      endfunction

      autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
      autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
    ]]
    vim.g.php_namespace_sort_use_statements = 1
  end,
}
