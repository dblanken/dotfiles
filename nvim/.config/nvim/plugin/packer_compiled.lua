-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/dblanken/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/dblanken/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/dblanken/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/dblanken/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/dblanken/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  CamelCaseMotion = {
    keys = { { "", "<Leader>w" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/CamelCaseMotion"
  },
  LuaSnip = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.luasnip\frequire\0" },
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/LuaSnip",
    wants = { "friendly-snippets" }
  },
  corpus = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/corpus"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15statusline\frequire\0" },
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["glow.nvim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/glow.nvim"
  },
  ["gruvbox.nvim"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16colorscheme\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/gruvbox.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.autopairs\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-compe"] = {
    after = { "nvim-autopairs" },
    after_files = { "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18plugins.compe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-compe",
    wants = { "LuaSnip" }
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0" },
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    commands = { "PackerSync", "PackerClean", "PackerInstall", "PackerUpdate", "PackerStatus", "PackerCompile", "PackerLoad" },
    config = { "\27LJ\2\n'\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\fplugins\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ["presenting.vim"] = {
    commands = { "StartPresenting" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/presenting.vim"
  },
  ["splitjoin.vim"] = {
    keys = { { "n", "gS" }, { "n", "gJ" } },
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/splitjoin.vim"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/startuptime.vim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23dblanken.telescope\frequire\0" },
    keys = { { "", "<C-p>" }, { "", "<Leader>ff" }, { "", "<Leader>fg" }, { "", "<Leader>en" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["vim-bundler"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-bundler"
  },
  ["vim-coffee-script"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dispatch"] = {
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-dispatch"
  },
  ["vim-endwise"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-endwise"
  },
  ["vim-eunuch"] = {
    commands = { "Delete", "Rename" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-fugitive"] = {
    commands = { "G", "Gstatus", "Glog", "Gcommit", "Gdiff", "Gbrowse" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-git"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-git"
  },
  ["vim-jdaddy"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-jdaddy"
  },
  ["vim-markdown"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-markdown"
  },
  ["vim-projectionist"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-projectionist"
  },
  ["vim-ragtag"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-ragtag"
  },
  ["vim-rails"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-rails"
  },
  ["vim-rake"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-rake"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rhubarb"] = {
    commands = { "Gbrowse" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-rhubarb"
  },
  ["vim-ruby-refactoring"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-ruby-refactoring"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-surround"] = {
    keys = { { "n", "ds" }, { "n", "cs" }, { "n", "cS" }, { "n", "ys" }, { "n", "yS" }, { "n", "yss" }, { "n", "ySs" }, { "n", "ySS" }, { "x", "S" }, { "x", "gS" }, { "i", "<C-S>" }, { "i", "<C-G>s" }, { "i", "<C-G>S" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-test"] = {
    commands = { "TestFile", "TestNearest", "TestSuite", "TestLast" },
    config = { "\27LJ\2\n(\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\rvim-test\frequire\0" },
    keys = { { "", "<Leader>t" }, { "", "<Leader>T" }, { "", "<Leader>a" }, { "", "<Leader>l" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-test"
  },
  ["vim-textobj-rubyblock"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-rubyblock"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    keys = { { "", "<C-h>" }, { "", "<C-j>" }, { "", "<C-k>" }, { "", "<C-l>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    keys = { { "", "[q" }, { "", "]q" }, { "", "]f" }, { "", "[f" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-unimpaired"
  },
  ["vim-vinegar"] = {
    keys = { { "", "-" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-vinegar"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^lspsaga"] = "lspsaga.nvim",
  ["^packer%.nvim"] = "packer.nvim",
  ["^plenary"] = "plenary.nvim",
  ["^telescope"] = "telescope.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: CamelCaseMotion
time([[Setup for CamelCaseMotion]], true)
try_loadstring("\27LJ\2\n>\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\r<leader>\24camelcasemotion_key\6g\bvim\0", "setup", "CamelCaseMotion")
time([[Setup for CamelCaseMotion]], false)
-- Setup for: vim-rhubarb
time([[Setup for vim-rhubarb]], true)
try_loadstring("\27LJ\2\nR\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\26https://github.iu.edu\27github_enterprise_urls\6g\bvim\0", "setup", "vim-rhubarb")
time([[Setup for vim-rhubarb]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15statusline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.luasnip\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Conditional loads
time("Condition for { 'vim-projectionist' }", true)
if
try_loadstring("\27LJ\2\n_\0\0\3\0\4\0\f6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2)\1\0\0\0\1\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\24./.projections.json\17filereadable\afn\bvim\0", "condition", '{ "vim-projectionist" }')
then
time("Condition for { 'vim-projectionist' }", false)
time([[packadd for vim-projectionist]], true)
		vim.cmd [[packadd vim-projectionist]]
	time([[packadd for vim-projectionist]], false)
else
time("Condition for { 'vim-projectionist' }", false)
end
time("Condition for { 'vim-rails', 'vim-rake', 'vim-bundler' }", true)
if
try_loadstring("\27LJ\2\n}\0\0\3\0\5\0\0206\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2)\1\0\0\0\1\0\0X\0\n€6\0\0\0009\0\1\0009\0\2\0'\2\4\0B\0\2\2)\1\0\0\0\1\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\14config.ru\fGemfile\17filereadable\afn\bvim\0", "condition", '{ "vim-rails", "vim-rake", "vim-bundler" }')
then
time("Condition for { 'vim-rails', 'vim-rake', 'vim-bundler' }", false)
time([[packadd for vim-rails]], true)
		vim.cmd [[packadd vim-rails]]
	time([[packadd for vim-rails]], false)
	time([[packadd for vim-rake]], true)
		vim.cmd [[packadd vim-rake]]
	time([[packadd for vim-rake]], false)
	time([[packadd for vim-bundler]], true)
		vim.cmd [[packadd vim-bundler]]
	time([[packadd for vim-bundler]], false)
else
time("Condition for { 'vim-rails', 'vim-rake', 'vim-bundler' }", false)
end

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Gbrowse lua require("packer.load")({'vim-rhubarb', 'vim-fugitive'}, { cmd = "Gbrowse", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TestFile lua require("packer.load")({'vim-test'}, { cmd = "TestFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TestNearest lua require("packer.load")({'vim-test'}, { cmd = "TestNearest", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TestSuite lua require("packer.load")({'vim-test'}, { cmd = "TestSuite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file TestLast lua require("packer.load")({'vim-test'}, { cmd = "TestLast", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Gdiff lua require("packer.load")({'vim-fugitive'}, { cmd = "Gdiff", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerSync lua require("packer.load")({'packer.nvim'}, { cmd = "PackerSync", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerClean lua require("packer.load")({'packer.nvim'}, { cmd = "PackerClean", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerInstall lua require("packer.load")({'packer.nvim'}, { cmd = "PackerInstall", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerUpdate lua require("packer.load")({'packer.nvim'}, { cmd = "PackerUpdate", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerStatus lua require("packer.load")({'packer.nvim'}, { cmd = "PackerStatus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerCompile lua require("packer.load")({'packer.nvim'}, { cmd = "PackerCompile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file PackerLoad lua require("packer.load")({'packer.nvim'}, { cmd = "PackerLoad", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file StartPresenting lua require("packer.load")({'presenting.vim'}, { cmd = "StartPresenting", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file G lua require("packer.load")({'vim-fugitive'}, { cmd = "G", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Gstatus lua require("packer.load")({'vim-fugitive'}, { cmd = "Gstatus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Glog lua require("packer.load")({'vim-fugitive'}, { cmd = "Glog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Gcommit lua require("packer.load")({'vim-fugitive'}, { cmd = "Gcommit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> - <cmd>lua require("packer.load")({'vim-vinegar'}, { keys = "-", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> <C-G>s <cmd>lua require("packer.load")({'vim-surround'}, { keys = "<lt>C-G>s" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> [q <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "[q", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> [f <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "[f", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> ]f <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "]f", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-l> <cmd>lua require("packer.load")({'vim-tmux-navigator'}, { keys = "<lt>C-l>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-k> <cmd>lua require("packer.load")({'vim-tmux-navigator'}, { keys = "<lt>C-k>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> <C-G>S <cmd>lua require("packer.load")({'vim-surround'}, { keys = "<lt>C-G>S" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> ySS <cmd>lua require("packer.load")({'vim-surround'}, { keys = "ySS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gJ <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gJ", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[inoremap <silent> <C-S> <cmd>lua require("packer.load")({'vim-surround'}, { keys = "<lt>C-S>" }, _G.packer_plugins)<cr>]]
vim.cmd [[xnoremap <silent> gS <cmd>lua require("packer.load")({'vim-surround'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[xnoremap <silent> S <cmd>lua require("packer.load")({'vim-surround'}, { keys = "S", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> cs <cmd>lua require("packer.load")({'vim-surround'}, { keys = "cs", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>l <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>Leader>l", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> cS <cmd>lua require("packer.load")({'vim-surround'}, { keys = "cS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> ys <cmd>lua require("packer.load")({'vim-surround'}, { keys = "ys", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> ds <cmd>lua require("packer.load")({'vim-surround'}, { keys = "ds", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>w <cmd>lua require("packer.load")({'CamelCaseMotion'}, { keys = "<lt>Leader>w", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> yss <cmd>lua require("packer.load")({'vim-surround'}, { keys = "yss", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> yS <cmd>lua require("packer.load")({'vim-surround'}, { keys = "yS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> ySs <cmd>lua require("packer.load")({'vim-surround'}, { keys = "ySs", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>t <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>Leader>t", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-p> <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>C-p>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>ff <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>Leader>ff", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>fg <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>Leader>fg", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>en <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>Leader>en", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[nnoremap <silent> gS <cmd>lua require("packer.load")({'splitjoin.vim'}, { keys = "gS", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>T <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>Leader>T", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <Leader>a <cmd>lua require("packer.load")({'vim-test'}, { keys = "<lt>Leader>a", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-h> <cmd>lua require("packer.load")({'vim-tmux-navigator'}, { keys = "<lt>C-h>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> ]q <cmd>lua require("packer.load")({'vim-unimpaired'}, { keys = "]q", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-j> <cmd>lua require("packer.load")({'vim-tmux-navigator'}, { keys = "<lt>C-j>", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-markdown', 'glow.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'vim-ragtag'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType htmljinja ++once lua require("packer.load")({'vim-endwise'}, { ft = "htmljinja" }, _G.packer_plugins)]]
vim.cmd [[au FileType git ++once lua require("packer.load")({'vim-git'}, { ft = "git" }, _G.packer_plugins)]]
vim.cmd [[au FileType vb ++once lua require("packer.load")({'vim-endwise'}, { ft = "vb" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'vim-jdaddy'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType gitcommit ++once lua require("packer.load")({'vim-git'}, { ft = "gitcommit" }, _G.packer_plugins)]]
vim.cmd [[au FileType matlab ++once lua require("packer.load")({'vim-endwise'}, { ft = "matlab" }, _G.packer_plugins)]]
vim.cmd [[au FileType jinja.html ++once lua require("packer.load")({'vim-endwise'}, { ft = "jinja.html" }, _G.packer_plugins)]]
vim.cmd [[au FileType htmldjango ++once lua require("packer.load")({'vim-endwise'}, { ft = "htmldjango" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'vim-endwise'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType mason ++once lua require("packer.load")({'vim-ragtag'}, { ft = "mason" }, _G.packer_plugins)]]
vim.cmd [[au FileType snippets ++once lua require("packer.load")({'vim-endwise'}, { ft = "snippets" }, _G.packer_plugins)]]
vim.cmd [[au FileType verilog ++once lua require("packer.load")({'vim-endwise'}, { ft = "verilog" }, _G.packer_plugins)]]
vim.cmd [[au FileType cpp ++once lua require("packer.load")({'vim-endwise'}, { ft = "cpp" }, _G.packer_plugins)]]
vim.cmd [[au FileType objc ++once lua require("packer.load")({'vim-endwise'}, { ft = "objc" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'vim-endwise'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType c ++once lua require("packer.load")({'vim-endwise'}, { ft = "c" }, _G.packer_plugins)]]
vim.cmd [[au FileType elixir ++once lua require("packer.load")({'vim-endwise'}, { ft = "elixir" }, _G.packer_plugins)]]
vim.cmd [[au FileType xdefaults ++once lua require("packer.load")({'vim-endwise'}, { ft = "xdefaults" }, _G.packer_plugins)]]
vim.cmd [[au FileType ruby ++once lua require("packer.load")({'vim-ruby-refactoring', 'vim-textobj-rubyblock', 'vim-endwise'}, { ft = "ruby" }, _G.packer_plugins)]]
vim.cmd [[au FileType make ++once lua require("packer.load")({'vim-endwise'}, { ft = "make" }, _G.packer_plugins)]]
vim.cmd [[au FileType eruby ++once lua require("packer.load")({'vim-ragtag'}, { ft = "eruby" }, _G.packer_plugins)]]
vim.cmd [[au FileType coffee ++once lua require("packer.load")({'vim-coffee-script'}, { ft = "coffee" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'vim-endwise'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType crystal ++once lua require("packer.load")({'vim-endwise'}, { ft = "crystal" }, _G.packer_plugins)]]
vim.cmd [[au FileType vbnet ++once lua require("packer.load")({'vim-endwise'}, { ft = "vbnet" }, _G.packer_plugins)]]
vim.cmd [[au FileType aspvbs ++once lua require("packer.load")({'vim-endwise'}, { ft = "aspvbs" }, _G.packer_plugins)]]
vim.cmd [[au FileType zsh ++once lua require("packer.load")({'vim-endwise'}, { ft = "zsh" }, _G.packer_plugins)]]
vim.cmd [[au FileType haskell ++once lua require("packer.load")({'vim-endwise'}, { ft = "haskell" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'nvim-treesitter'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHoldI * ++once lua require("packer.load")({'nvim-treesitter'}, { event = "CursorHoldI *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'gruvbox.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-git/ftdetect/git.vim]], true)
vim.cmd [[source /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-git/ftdetect/git.vim]]
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-git/ftdetect/git.vim]], false)
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], true)
vim.cmd [[source /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-markdown/ftdetect/markdown.vim]], false)
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/coffee.vim]], true)
vim.cmd [[source /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/coffee.vim]]
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/coffee.vim]], false)
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/vim-literate-coffeescript.vim]], true)
vim.cmd [[source /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/vim-literate-coffeescript.vim]]
time([[Sourcing ftdetect script at: /Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-coffee-script/ftdetect/vim-literate-coffeescript.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
