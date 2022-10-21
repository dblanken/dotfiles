set nocompatible

let mapleader = "\<Space>"

function! s:SourceConfigFilesIn(directory)
	let directory_splat = '~/.vim/' . a:directory . '/*'
	for config_file in split(glob(directory_splat), '\n')
		if filereadable(config_file)
			execute 'source' config_file
		endif
	endfor
endfunction

set shell=/usr/local/bin/zsh

call plug#begin('~/.local/share/vim/bundle')
call s:SourceConfigFilesIn('rcplugins')
call plug#end()

call s:SourceConfigFilesIn('rcfiles')
