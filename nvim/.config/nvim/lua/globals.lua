local g = vim.g

-- Set host progs so they don't have to find them
g.python_host_prog = vim.fn.expand('~/.asdf/shims/python2')
g.python3_host_prog = vim.fn.expand('~/.asdf/shims/python3')
g.ruby_host_prog = vim.fn.expand('~/.asdf/shims/neovim-ruby-host')
g.node_host_prog = vim.fn.expand('~/.config/yarn/global/node_modules/neovim/bin/cli.js')
g.perl_host_prog = vim.fn.expand('~/.asdf/shims/perl')
