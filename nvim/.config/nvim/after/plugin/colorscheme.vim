if g:my_color_scheme == 'gruvbox'
  let g:gruvbox_italic = 1
  let g:gruvbox_transparent_bg = 1
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_italicize_strings = 1
elseif g:my_color_scheme == 'dracula'
  let g:dracula_bold = 1
  let g:dracula_italic = 1
  let g:dracula_underline = 1
  let g:dracula_undercurl = 1
else
  let g:my_color_scheme = 'desert'
end

call transparency#enable()
execute "colorscheme " . g:my_color_scheme
