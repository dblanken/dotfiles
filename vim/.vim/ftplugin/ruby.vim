if exists('g:loaded_ruby_stuff')
	finish
endif
let g:loaded_ruby_stuff = 1

runtime macros/matchit.vim
packadd vim-textobj-user
packadd vim-textobj-rubyblock
packadd CamelCaseMotion
