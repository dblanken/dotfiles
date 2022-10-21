# General ZSH functions
#
sz() { source ~/.zshrc }

first() { awk '{print $1}' }
second() { awk '{print $2}' }
sum() { paste -sd+ - | bc }
