return {
  "vimwiki/vimwiki",
  lazy = false,
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/Documents/vimwiki",
        syntax = "markdown",
        ext = ".md"
      }
    }

    vim.treesitter.language.register('markdown', 'vimwiki')
  end
}
