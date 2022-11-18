unsetopt auto_cd
cdpath=(
	$HOME/code \
	$HOME/code/work \
	$HOME
)

# Taken from rbates: https://github.com/ryanb/dotfiles/blob/master/oh-my-zsh/custom/plugins/rbates/rbates.plugin.zsh
# Allows you to easily cd into code directory with completion
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c