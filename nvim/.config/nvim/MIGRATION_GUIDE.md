# LazyVim to Custom Config Migration Guide

This guide explains how your Neovim configuration has been structured to incorporate LazyVim best practices without depending on the LazyVim distribution.

## What Was Done

### 1. Created Core Configuration Structure

Your custom config now has a proper structure with separate concerns:

```
~/.config/nvim/
├── init.lua                          # Main entry point
├── lua/custom/
│   ├── config/
│   │   ├── options.lua              # ✨ NEW: Vim options
│   │   ├── keymaps.lua              # ✨ NEW: Key mappings
│   │   └── autocmds.lua             # ✨ NEW: Autocommands
│   └── plugins/
│       ├── *.lua                    # Your plugin configurations
│       └── init.lua                 # Empty file for plugin overrides
```

### 2. Updated init.lua

Your `init.lua` now:
- Sets leader keys early
- Loads the new config modules
- Bootstraps lazy.nvim
- Includes performance optimizations from LazyVim

### 3. Enhanced LSP Configuration

`lua/custom/plugins/lsp.lua` now includes:
- **phpactor** configuration from your LazyVim setup (currently active)
- **intelephense** commented out for easy switching
- All your existing Mason and conform.nvim setup

**To switch PHP LSP:**
- Comment out the `phpactor` block (lines 41-54)
- Uncomment the `intelephense` block (lines 55-77)

## Configuration Files Explained

### options.lua
Contains all Vim settings:
- Line numbers, indentation, search behavior
- Appearance (colors, cursor, splits)
- Completion settings
- Folding with treesitter
- Performance settings

### keymaps.lua
Defines key mappings:
- Better movement on wrapped lines (j/k)
- Visual mode line movement (J/K)
- Buffer and window navigation
- LSP and diagnostic mappings
- Oil file browser (`-`)

### autocmds.lua
Automatic behaviors:
- Highlight on yank
- Auto-resize splits
- Close helpers with `q`
- Jump to last position
- Auto-check for file changes

## Your Existing Plugins

These plugins from your custom config are already great and unchanged:

### Core Tools
- **telescope.nvim** - Fuzzy finder (your config is excellent)
- **nvim-cmp** - Completion (with copilot integration)
- **treesitter** - Syntax highlighting (very comprehensive)
- **oil.nvim** - File browser
- **conform.nvim** - Formatting (integrated in LSP config)

### Git & Development
- **fugitive** - Git integration
- **dispatch** - Async command execution
- **projectionist** - Project navigation
- **gutentags** - Tag management
- **vim-tmux-navigator** - Seamless tmux/vim navigation

### Database & Special Tools
- **dadbod** - Database interface
- **copilot** - AI assistance
- **ollama** - Local LLM
- **markdown-preview** - Markdown preview
- **undotree** - Undo history
- **dap** - Debug adapter protocol

### Utilities
- **plenary** - Lua utilities
- **mini** - Collection of mini plugins
- **eunuch** - Unix helpers
- **unimpaired** - Bracket mappings
- **lualine** - Status line

## Plugins from LazyVim You Might Want

These are configured in your LazyVim setup but not in custom config yet:

### Worth Adding
1. **noice.nvim** - Better UI for messages, cmdline, and popupmenu
   - Currently disabled in your LazyVim
   - Can add if you want modern UI

2. **nvim-notify** - Fancy notifications
   - Part of LazyVim's UI experience

3. **which-key.nvim** - Show available keybindings
   - Very helpful for discovering commands

4. **mini.pairs** - Auto-close brackets
   - Likely already have from mini plugins

### LazyVim Extras
Your LazyVim config has these custom plugins:
- `azure-functions.lua` - Azure development
- `claude-code.lua` - Claude Code integration
- `db.lua` - Database helpers
- `gp.lua` - GPT integration
- `tempfix.lua` - Temporary fixes
- `vimwiki.lua` - Wiki/notes

**These are already in your LazyVim config and can be copied to custom if needed.**

## How to Add More Plugins

### Option 1: Add Individual Plugins (Recommended)

Create a new file in `lua/custom/plugins/`:

```lua
-- lua/custom/plugins/which-key.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration here
  },
}
```

### Option 2: Browse LazyVim Source

1. Visit https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins
2. Find a plugin you want
3. Copy its configuration to your `lua/custom/plugins/`
4. Adapt as needed (remove LazyVim-specific utilities)

### Option 3: Import LazyVim Core (Not Recommended)

You could add LazyVim as a dependency:

```lua
-- In lazy.setup()
require("lazy").setup({
  { "LazyVim/LazyVim" },  -- Core utilities only
  { import = "custom/plugins" },
})
```

**Why not recommended:** You want a standalone config, not a wrapper.

## Testing Your New Config

### Start Fresh
```bash
# Use your custom config
nvim

# Check health
:checkhealth

# View loaded plugins
:Lazy

# Test LSP
:LspInfo
```

### Common Issues

**Problem:** LSP not working
- **Solution:** Run `:Mason` and ensure servers are installed

**Problem:** Keymaps not working
- **Solution:** Check `lua/custom/config/keymaps.lua` for conflicts

**Problem:** Missing plugin
- **Solution:** Run `:Lazy sync` to install/update all plugins

**Problem:** Formatting not working
- **Solution:** Check conform.nvim setup in `lua/custom/plugins/lsp.lua`

## Switching Between Configs

You can keep both configs and switch between them:

```bash
# Use your custom config (default)
nvim

# Use LazyVim config
NVIM_APPNAME=lazyvim nvim
```

Set in your `.zshrc`:
```bash
export NVIM_APPNAME=nvim        # Use custom config
# export NVIM_APPNAME=lazyvim   # Use LazyVim config
```

## Next Steps

### Recommended Actions

1. **Test the new config**
   ```bash
   nvim ~/.config/nvim/MIGRATION_GUIDE.md
   ```

2. **Try different features**
   - Press `<Space>` and wait to see available commands
   - Try `:Telescope` commands with `<Space>f...`
   - Test LSP with `gd` (go to definition), `K` (hover)

3. **Customize further**
   - Edit `lua/custom/config/options.lua` for your preferences
   - Add/modify keymaps in `lua/custom/config/keymaps.lua`
   - Add new plugins as needed

4. **Copy useful plugins from LazyVim**
   - Browse your `~/.config/lazyvim/lua/plugins/`
   - Pick ones you use regularly
   - Copy to `~/.config/nvim/lua/custom/plugins/`

### Optional: Copy Specific LazyVim Plugins

Want a plugin from your LazyVim config? Copy it:

```bash
# Example: Copy claude-code plugin
cp ~/.config/lazyvim/lua/plugins/claude-code.lua \
   ~/.config/nvim/lua/custom/plugins/
```

Then edit to remove LazyVim-specific code if needed.

## Philosophy

**LazyVim Approach:**
- Distribution with opinionated defaults
- Easy to get started
- Less understanding of internals

**Your Custom Config:**
- Full control and understanding
- Cherry-pick features you want
- Clean, maintainable codebase
- No "magic" from distribution layer

You now have a solid foundation that incorporates LazyVim's best practices while remaining fully independent and customizable.

## Key Differences from LazyVim

| Aspect | LazyVim | Your Custom Config |
|--------|---------|-------------------|
| **Structure** | Imports `lazyvim.plugins` | Standalone, no dependencies |
| **Defaults** | Many pre-configured plugins | Only what you explicitly add |
| **Extras** | LazyVim extras system | Manual plugin addition |
| **Utilities** | `LazyVim.*` helper functions | Direct Vim/Lua APIs |
| **Updates** | LazyVim version updates | Only your own changes |
| **Control** | Some "magic" behind scenes | Full transparency |

## Support

If something breaks:
1. Check `:checkhealth`
2. Look at `:messages` for errors
3. Test with `:Lazy sync` to update plugins
4. Compare with your LazyVim config if needed

Your LazyVim config is still intact at `~/.config/lazyvim/` - you can always reference it or switch back using `NVIM_APPNAME=lazyvim nvim`.
