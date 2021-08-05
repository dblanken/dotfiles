vim.cmd [[
let g:rails_projections = { "test/models/*_test.rb": {"command": "modeltest", "template": ["require \"test_helper\"", "", "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase", "end"] } }
]]
