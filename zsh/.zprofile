export SHELL_SESSIONS_DISABLE=1

if [ -d "$HOME/.zsh/zprofile" ]
then
  for zsh_file in ~/.zsh/zprofile/*; do
	  source $zsh_file
  done
fi
