local status_ok, endwise = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

endwise.setup {
  endwise = {
    enable = true
  }
}
