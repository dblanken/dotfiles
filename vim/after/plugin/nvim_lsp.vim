if !has('nvim')
  finish
endif

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
set signcolumn=yes
" Avoid showing message extra message when using completion
set shortmess+=c

" Fix up diagnostic and completion to use fuzzy finding and Ultisnips
let g:diagnostic_enable_virtual_text = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1
let g:completion_enable_snippet = 'UltiSnips'

lua <<EOF
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local nvim_lsp = require('nvim_lsp')

local on_attach_vim = function()
  require'completion'.on_attach()
  require'diagnostic'.on_attach(vim.lsp.client)
end

nvim_lsp.bashls.setup{on_attach=on_attach_vim}
nvim_lsp.cssls.setup{on_attach=on_attach_vim}
nvim_lsp.html.setup{on_attach=on_attach_vim}
nvim_lsp.jsonls.setup{on_attach=on_attach_vim}
nvim_lsp.pyls.setup{on_attach=on_attach_vim}
nvim_lsp.solargraph.setup{
  on_attach=on_attach_vim,
  settings={
    solargraph={
      diagnostics=true,
      formatting=true
    }
  }
}
nvim_lsp.tsserver.setup{on_attach=on_attach_vim}
nvim_lsp.vimls.setup{on_attach=on_attach_vim}
nvim_lsp.yamlls.setup{on_attach=on_attach_vim}
EOF

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <Leader>k <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" In the style of vim-unimpaired
nnoremap ]w :PrevDiagnosticCycle<CR>
nnoremap [w :NextDiagnosticCycle<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <Leader>rn :lua vim.lsp.buf.rename()<CR>

" Completion with snippets, endwises, and autopairs
" We need to do our own mappings for these, so disable the mapping of the
" other plugins
let g:AutoPairsMapCR = 0
let g:endwise_no_mappings = 1
let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
      \ "\<Plug>(completion_confirm_completion)"  :
      \ "\<c-e>\<CR>" : "\<CR>\<Plug>DiscretionaryEnd\<Plug>AutoPairsReturn"
