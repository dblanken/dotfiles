local present, treesitter = pcall(require, "nvim-treesitter")
if not present then
  return
end

require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
    config = {
      ruby = '# %s'
    }
  }
}

