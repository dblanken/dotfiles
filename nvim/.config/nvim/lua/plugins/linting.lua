return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require('lint')
    local masonBinPath = vim.fn.stdpath('data') .. '/mason/bin'

    -- Use mason's twigcs
    lint.linters.twigcs.cmd = masonBinPath .. "/twigcs"

    -- PHPCS
    local phpcs = lint.linters.phpcs

    local git_dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    local phpcs_bin = vim.fn.expand(git_dir .. '/vendor/bin/phpcs')

    if vim.fn.filereadable(phpcs_bin) == 1 then
      phpcs.cmd = phpcs_bin

      phpcs.args = {
        '-q',
        '--report=json',
        '--standard=Drupal,DrupalPractice',
        '--extensions=php,module,inc,install,test,profile,theme,info,txt',
        '-', -- need `-` at the end for stdin support
      }
    end

    lint.linters_by_ft = {
      php = { 'phpcs' },
      markdown = { 'markdownlint', 'write-good' },
      sh = { 'shellcheck' },
      yaml = { 'yamllint' },
      twig = { 'twigcs' },
      javascript = { 'eslint_d' },
      html = { 'htmlhint' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      sass = { 'stylelint' },
      less = { 'stylelint' },
    }

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "TextChanged", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
