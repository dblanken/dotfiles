require('dblanken.lsp.lsp-installer')
require('dblanken.lsp.handlers').setup()

-- Load outside of lsp-installer so we use asdf ruby
require('dblanken.lsp.solargraph')
