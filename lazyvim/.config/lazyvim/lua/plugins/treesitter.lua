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
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      -- Free up ]f/[f (and the ]F/[F function-end motions) so vim-unimpaired's
      -- next/previous-file mappings win. LazyVim registers these as buffer-local
      -- treesitter motions, which otherwise shadow unimpaired's global mappings.
      opts.move.keys.goto_next_start["]f"] = nil
      opts.move.keys.goto_previous_start["[f"] = nil
      opts.move.keys.goto_next_end["]F"] = nil
      opts.move.keys.goto_previous_end["[F"] = nil
    end,
  },
}
