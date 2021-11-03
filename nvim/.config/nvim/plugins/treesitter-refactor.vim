Plug 'nvim-treesitter/nvim-treesitter-refactor'

function! SetupRefactorOverrides() abort
lua <<EOF
require'nvim-treesitter.configs'.setup {
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
}
EOF
endfunction

augroup TreesitterRefactorOverrides
    autocmd!
    autocmd User PlugLoaded call SetupRefactorOverrides()
augroup END
