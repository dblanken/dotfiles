local phpcs = {
  args = {
    "-q",
    "--report=json",
    "--extensions=php,module,inc,install,test,profile,theme,info,txt",
    "-", -- need `-` at the end for stdin support
  },
}

local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
local coder_location = vim.fn.expand(git_dir .. "/vendor/drupal/coder/coder_sniffer/Drupal/ruleset.xml")

if vim.fn.filereadable(coder_location) == 1 then
  table.insert(phpcs.args, 3, "--standard=Drupal,DrupalPractice")
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      phpcs = phpcs,
    },
  },
}
