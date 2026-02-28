return {
  {
    "tpope/vim-projectionist",
    config = function()
      vim.g.projectionist_heuristics = {
        ["&pantheon.yml"] = {
          ["*"] = { ["dispatch"] = "lando drush cr" },
          ["web/core/modules/*.php"] = {
            ["type"] = "core",
          },
          ["web/profiles/custom/yalesites_profile/modules/*.php"] = {
            ["type"] = "profile",
          },
        },
        ["&atomic.info.yml"] = {
          ["*"] = { ["dispatch"] = "lando drush cr" },
          ["templates/*.html.twig"] = {
            ["type"] = "template",
          },
        },
        ["webpack/webpack.common.js"] = {
          ["*"] = { ["dispatch"] = "npm run build" },
          ["components/*.twig"] = {
            ["type"] = "components",
          },
          ["components/*.scss"] = {
            ["type"] = "scss",
          },
          ["components/*.js"] = {
            ["type"] = "js",
          },
          ["components/*.yml"] = {
            ["type"] = "yml",
          },
        },
      }
    end,
  },
}
