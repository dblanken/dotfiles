# Allows you to easily cd into code directory with completion
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c
