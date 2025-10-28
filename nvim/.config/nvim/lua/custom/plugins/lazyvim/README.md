# LazyVim Plugin Library

This directory contains 26 individual plugin configurations extracted from LazyVim, merged with your custom overrides. Each plugin is in its own file and can be independently enabled or disabled.

## Quick Start

### Enable a Plugin
Open the plugin file and set `local enabled = true`

### Disable a Plugin  
Open the plugin file and set `local enabled = false`

Then restart Neovim and run `:Lazy sync`

## Complete Plugin List

Run `ls -1 *.lua` in this directory to see all available plugins.

**Key plugins with your custom overrides:**
- `conform.lua` - Has your PHP/Drupal formatting setup
- `nvim-lspconfig.lua` - Has your phpactor and other LSP servers
- `copilot.lua` - Your Copilot configuration
- `cmp.lua` - Your completion customization
- `oil.lua` - Your file browser setup
- `colorscheme.lua` - Your color scheme

**All other plugins are LazyVim defaults**, adapted to work standalone without LazyVim.

## Recommended Starting Set

Enable these for a solid foundation:
1. `nvim-lspconfig.lua` - LSP (includes your Drupal PHP setup)
2. `mason.lua` - Install LSP servers  
3. `conform.lua` - Formatting (includes your phpcbf)
4. `nvim-treesitter.lua` - Syntax
5. `which-key.lua` - Keymap helper
6. `gitsigns.lua` - Git integration
7. `lualine.lua` - Status line
8. `trouble.lua` - Better diagnostics
9. `mini-pairs.lua` - Auto-close brackets
10. `flash.lua` - Fast navigation

See individual files for what each plugin does!
