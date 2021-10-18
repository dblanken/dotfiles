" it must wait until VimEnter
augroup CamelCaseMotions
 au!
 autocmd VimEnter call camelcasemotion#CreateMotionMappings('<leader>')
augroup END
