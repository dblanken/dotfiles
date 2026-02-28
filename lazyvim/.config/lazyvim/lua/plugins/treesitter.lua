return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "php",
        "printf",
        "python",
        "regex",
        "scss",
        "twig",
        "typescript",
        "tsx",
        "vim",
        "xml",
        "yaml",
      },
      textobjects = {
        move = {
          enable = false
        }
      }
    },
  },
}
