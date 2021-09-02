local opt = vim.opt
local g = vim.g

local home = vim.env.HOME
local config = home .. '/.config/nvim'
local data = home .. '/.local/share/nvim'
local root = vim.env.USER == 'root'
local vi = vim.v.progname == 'vi'

opt.shadafile = "NONE"                                 -- don't write on startup (enabled in lua/utils.lua)

opt.backup         = false                             -- don't make backups before writing
opt.backupcopy     = 'yes'                             -- overwrite files to update, instead of renaming + rewriting
opt.backupdir      = data .. '/backup//'               -- keep backup files out of the way (ie. if 'backup' is ever set)
opt.completeopt    = 'menuone,noselect'                -- show menu even if there is only one candidate (for nvim-compe)
opt.cursorline     = true                              -- highlight current line
opt.diffopt        = opt.diffopt + 'foldcolumn:0'      -- don't show fold column in diff view
opt.directory      = data .. '/nvim/swap//'            -- keep swap files out of the way
opt.expandtab      = true                              -- always use spaces instead of tabs
opt.formatoptions  = opt.formatoptions + 'n'           -- smart auto-indenting inside numbered lists
opt.hidden         = true                              -- allows you to hide buffers with unsaved changes without being prompted
opt.inccommand     = 'split'                           -- live preview of :s results
opt.joinspaces     = false                             -- don't autoinsert two spaces after '.', '?', '!' for join command
opt.lazyredraw     = true                              -- don't bother updating screen during macro playback
opt.linebreak      = true                              -- wrap long lines at characters in 'breakat'
opt.list           = true                              -- show whitespace

if vi then
  opt.loadplugins = false
end

opt.number         = true -- show line numbers in gutter
opt.relativenumber = true -- show relative numbers in gutter
if root then
  opt.shada     = '' -- Don't create root-owned files.
  opt.shadafile = 'NONE'
else
  -- Defaults:
  --   Neovim: !,'100,<50,s10,h
  --
  -- - ! save/restore global variables (only all-uppercase variables)
  -- - '100 save/restore marks from last 100 files
  -- - <50 save/restore 50 lines from each register
  -- - s10 max item size 10KB
  -- - h do not save/restore 'hlsearch' setting
  --
  -- Our overrides:
  -- - '0 store marks for 0 files
  -- - <0 don't save registers
  -- - f0 don't store file marks
  -- - n: store in ~/.config/nvim/
  --
  opt.shada = "'0,<0,f0,n~/.config/nvim/shada"
end

opt.shell         = 'sh'                    -- shell to use for `!`, `:!`, `system()` etc.
opt.shiftround    = false                   -- don't always indent by multiple of shiftwidth
opt.shiftwidth    = 2                       -- spaces per tab (when shifting)
opt.shortmess     = opt.shortmess + 'A'     -- ignore annoying swapfile messages
opt.shortmess     = opt.shortmess + 'I'     -- no splash screen
opt.shortmess     = opt.shortmess + 'O'     -- file-read message overwrites previous
opt.shortmess     = opt.shortmess + 'T'     -- truncate non-file messages in middle
opt.shortmess     = opt.shortmess + 'W'     -- don't echo "[w]"/"[written]" when writing
opt.shortmess     = opt.shortmess + 'a'     -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
opt.shortmess     = opt.shortmess + 'c'     -- completion messages
opt.shortmess     = opt.shortmess + 'o'     -- overwrite file-written messages
opt.shortmess     = opt.shortmess + 't'     -- truncate file messages at start
opt.showcmd       = false                   -- don't show extra info at end of command line
opt.signcolumn    = 'yes'                   -- always show sign column
opt.smarttab      = true                    -- <tab>/<BS> indent/dedent in leading whitespace
if not vi then
  opt.softtabstop = -1 -- use 'shiftwidth' for tab/bs at end of line
end
opt.spellcapcheck = ''                      -- don't check for capital letters at start of sentence
opt.splitbelow    = true                    -- open horizontal splits below current window
opt.splitright    = true                    -- open vertical splits to the right of the current window
opt.swapfile      = false                   -- don't create swap files
opt.switchbuf     = 'usetab'                -- try to reuse windows/tabs when switching buffers
opt.synmaxcol     = 200                     -- don't bother syntax highlighting long lines
opt.tabstop       = 2                       -- spaces per tab
opt.termguicolors = false                   -- use guifg/guibg instead of ctermfg/ctermbg in terminal
opt.textwidth     = 80                      -- automatically hard wrap at 80 columns
opt.updatetime  = 2000                      -- CursorHold interval
opt.updatecount = 0                         -- update swapfiles every 80 typed chars
opt.viewdir     = data .. '/view'           -- where to store files for :mkview
if root then
  opt.undofile = false -- don't create root-owned files
else
  opt.undodir  = data .. '/undo//'   -- keep undo files out of the way
  opt.undodir  = opt.undodir + '.' -- fallback
  opt.undofile = true                  -- actually use undo files
end
opt.viewoptions = 'cursor,folds'            -- save/restore just these (with `:{mk,load}view`)
opt.virtualedit = 'block'                   -- allow cursor to move where there is no text in visual block mode
opt.visualbell  = true                      -- stop annoying beeping for non-error errors
opt.whichwrap   = 'b,h,l,s,<,>,[,],~'       -- allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
opt.wildcharm   = 26                        -- ('<C-z>') substitute for 'wildchar' (<Tab>) in macros
opt.wildmenu    = true                      -- show options as list when switching buffers etc
opt.wildmode    = 'longest:full,full'       -- shell-like autocomplete to unambiguous portion
opt.writebackup = false                     -- don't keep backups after writing

-- Shortcircuit searching for host programs
g.python_host_prog = home .. '/.asdf/shims/python2'
g.python3_host_prog = home .. '/.asdf/shims/python3'
g.ruby_host_prog = home .. '/.asdf/shims/neovim-ruby-host'
g.node_host_prog = home .. '/.config/yarn/global/node_modules/neovim/bin/cli.js'
g.perl_host_prog = home .. '/.asdf/shims/perl'

-- Disable built-in plugins
local disabled_built_ins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    -- "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

