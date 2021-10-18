Plug 'bkad/CamelCaseMotion'

augroup CamelCaseMotionSetup
  autocmd!
  autocmd VimEnter call camelcasemotion#CreateMotionMappings('<Leader>')
augroup END
