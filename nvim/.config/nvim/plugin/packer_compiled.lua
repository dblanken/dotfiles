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
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/CamelCaseMotion"
  },
  LuaSnip = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.luasnip\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    wants = { "friendly-snippets" }
  },
  ["friendly-snippets"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23plugins.statusline\frequire\0" },
    load_after = {
      ["nord.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/galaxyline.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim"
  },
  ["nord.nvim"] = {
    after = { "nvim-web-devicons", "galaxyline.nvim" },
    config = { "\27LJ\2\n%\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\ntheme\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nord.nvim"
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
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.lspconfig\frequire\0" },
    load_after = {
      ["nvim-lspinstall"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    after = { "nvim-lspconfig" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    load_after = {
      ["nord.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    after = { "popup.nvim" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ["popup.nvim"] = {
    load_after = {
      ["plenary.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/popup.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-media-files.nvim"] = {
    loaded = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/start/telescope-media-files.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["vim-abolish"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-abolish"
  },
  ["vim-bundler"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-bundler"
  },
  ["vim-commentary"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-dispatch"] = {
    after = { "vim-test" },
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-dispatch"
  },
  ["vim-eunuch"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-fugitive"] = {
    commands = { "G", "Gstatus", "Glog", "Gblame", "Gpush", "Gpull" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-rails"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.vim-rails\frequire\0" },
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
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-test"] = {
    commands = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21plugins.vim-test\frequire\0" },
    load_after = {
      ["vim-dispatch"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-test"
  },
  ["vim-textobj-entire"] = {
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-entire"
  },
  ["vim-textobj-indent"] = {
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-indent"
  },
  ["vim-textobj-line"] = {
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-line"
  },
  ["vim-textobj-rubyblock"] = {
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-rubyblock"
  },
  ["vim-textobj-syntax"] = {
    load_after = {
      ["vim-textobj-user"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-syntax"
  },
  ["vim-textobj-user"] = {
    after = { "vim-textobj-entire", "vim-textobj-indent", "vim-textobj-line", "vim-textobj-rubyblock", "vim-textobj-syntax", "CamelCaseMotion" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-unimpaired"
  },
  ["vim-vinegar"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/dblanken/.local/share/nvim/site/pack/packer/opt/vim-vinegar"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^lspsaga%.diagnostic"] = "lspsaga.nvim",
  ["^lspsaga%.hover"] = "lspsaga.nvim",
  ["^lspsaga%.rename"] = "lspsaga.nvim",
  ["^plugins%.telescope_custom"] = "telescope.nvim",
  ["^telescope"] = "telescope.nvim",
  ["^telescope%.builtin"] = "telescope.nvim"
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


-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Glog lua require("packer.load")({'vim-fugitive'}, { cmd = "Glog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestNearest lua require("packer.load")({'vim-test'}, { cmd = "TestNearest", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestFile lua require("packer.load")({'vim-test'}, { cmd = "TestFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestSuite lua require("packer.load")({'vim-test'}, { cmd = "TestSuite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TestLast lua require("packer.load")({'vim-test'}, { cmd = "TestLast", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gblame lua require("packer.load")({'vim-fugitive'}, { cmd = "Gblame", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gpush lua require("packer.load")({'vim-fugitive'}, { cmd = "Gpush", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gpull lua require("packer.load")({'vim-fugitive'}, { cmd = "Gpull", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gstatus lua require("packer.load")({'vim-fugitive'}, { cmd = "Gstatus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file G lua require("packer.load")({'vim-fugitive'}, { cmd = "G", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'vim-abolish'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHoldI * ++once lua require("packer.load")({'vim-abolish'}, { event = "CursorHoldI *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-bundler', 'vim-commentary', 'vim-surround', 'vim-textobj-user', 'vim-rake', 'vim-repeat', 'vim-tmux-navigator', 'vim-unimpaired', 'vim-vinegar', 'vim-rails', 'nord.nvim', 'vim-eunuch'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'nvim-lspinstall', 'nvim-treesitter', 'plenary.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'LuaSnip', 'friendly-snippets'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
