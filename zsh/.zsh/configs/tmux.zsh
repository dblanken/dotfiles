_not_inside_tmux() {
	[[ -z "$TMUX" ]]
}

ensure_tmux_is_running() {
	if _not_inside_tmux; then
		tmux attach || tmux -2 new -s $(hostname) && exit
	fi
}
