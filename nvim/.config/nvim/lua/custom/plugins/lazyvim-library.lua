-- LazyVim Plugin Library Index
-- This file provides a simple way to see and enable/disable LazyVim plugins
--
-- IMPORTANT: This is just a reference/index file.
-- To actually enable/disable plugins, edit the individual files in:
-- lua/custom/plugins/lazyvim/
--
-- Each plugin file has `local enabled = true/false` at the top.

--[[
## How to Use

1. Browse the list below to see available plugins
2. Open the plugin file you want (e.g., `nvim lua/custom/plugins/lazyvim/which-key.lua`)
3. Change `local enabled = false` to `local enabled = true`
4. Restart Neovim and run :Lazy sync

## Available Plugins by Category

### Coding & Editing Enhancements
- mini-pairs.lua          - Auto-close brackets, quotes
- ts-comments.lua         - Better comment syntax
- mini-ai.lua             - Extended text objects (functions, classes, etc.)
- lazydev.lua             - Lua development for Neovim configs
- flash.lua               - Enhanced navigation with labels
- grug-far.lua            - Multi-file search and replace
- copilot.lua             - GitHub Copilot (YOUR CUSTOM CONFIG)
- cmp.lua                 - Completion customization (YOUR CUSTOM CONFIG)

### UI & Visual
- bufferline.lua          - Fancy tab line
- lualine.lua             - Status line
- noice.lua               - Modern UI for messages/cmdline (optional, can be overwhelming)
- mini-icons.lua          - Icon provider
- nui.lua                 - UI component library
- colorscheme.lua         - Color scheme (YOUR CUSTOM CONFIG)

### Git Integration
- gitsigns.lua            - Git decorations and operations
- trouble.lua             - Better diagnostics/quickfix list

### File Navigation
- which-key.lua           - Keybinding popup helper
- oil.lua                 - Edit filesystem like buffer (YOUR CUSTOM CONFIG)

### LSP & Language Tools
- nvim-lspconfig.lua      - LSP client (INCLUDES YOUR DRUPAL/PHP SERVERS)
- mason.lua               - Package manager for LSP/formatters
- conform.lua             - Code formatting (INCLUDES YOUR PHPCBF/DRUPAL SETUP)
- nvim-lint.lua           - Async linting
- nvim-treesitter.lua     - Syntax highlighting
- nvim-treesitter-textobjects.lua - Treesitter text objects
- nvim-ts-autotag.lua     - Auto-close HTML tags
- todo-comments.lua       - Highlight TODO/FIXME comments

## Quick Enable Presets

Want to enable a sensible set quickly? Here are some command sequences:

### Minimal Setup (Essential Only)
cd ~/.config/nvim/lua/custom/plugins/lazyvim
# Enable these 5:
nvim nvim-lspconfig.lua   # Set enabled = true
nvim mason.lua            # Set enabled = true
nvim nvim-treesitter.lua  # Set enabled = true
nvim which-key.lua        # Set enabled = true
nvim gitsigns.lua         # Set enabled = true

### Recommended Setup (Good Balance)
# Add these 5 more to Minimal:
nvim conform.lua          # Set enabled = true
nvim mini-pairs.lua       # Set enabled = true
nvim lualine.lua          # Set enabled = true
nvim trouble.lua          # Set enabled = true
nvim flash.lua            # Set enabled = true

### Full Featured (Everything Useful)
# Add these to Recommended:
nvim bufferline.lua       # Set enabled = true
nvim grug-far.lua         # Set enabled = true
nvim todo-comments.lua    # Set enabled = true
nvim mini-ai.lua          # Set enabled = true
# Skip noice.lua unless you want fancy UI

## Your Custom Overrides

These files contain YOUR specific configurations merged with LazyVim:

1. conform.lua
   - Lines 40-48: PHP formatting with phpcbf + Drupal standards

2. nvim-lspconfig.lua
   - Lines 97-123: Your LSP servers (phpactor, bashls, cssls, ts_ls, jsonls, yamlls)
   - Full Drupal/PHP configuration

3. copilot.lua, cmp.lua, oil.lua, colorscheme.lua
   - Copied directly from your LazyVim config

## Total Count: 26 Plugins

All are disabled by default. Enable only what you need!
--]]

-- This file doesn't actually load anything.
-- It's just documentation/reference.
-- Delete it if you don't find it useful.

return {}
