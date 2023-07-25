vim.g.ale_disable_lsp = 1
vim.g.ale_echo_msg_format = '[%linter%] %code: %%s'
vim.g.ale_use_neovim_diagnostics_api = 1

vim.g.ale_php_phpcs_standard = 'Drupal,DrupalPractice'
vim.g.ale_php_phpcs_options = '--extensions=php,module,inc,install,test,profile,theme,info,txt'

vim.g.ale_php_phpcbf_standard = 'Drupal,DrupalPractice'
vim.g.ale_php_phpcbf_options = '--extensions=php,module,inc,install,test,profile,theme,info,txt'

vim.g.ale_fixers = {
  ['*'] = {
    'remove_trailing_lines',
    'trim_whitespace'
  },
  php = {
    'phpcbf'
  },
  javascript = {
    'eslint',
    'prettier'
  },
  twig = {
    'twigcs'
  },
}
