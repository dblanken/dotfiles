_not_inside_tmux() {
	[[ -z "$TMUX" ]]
}

ensure_tmux_is_running() {
	if _not_inside_tmux; then
    if [ "$(tty)" != "/dev/tty1" ]; then
      tmux attach || tmux -2 new -s $(hostname) && exit
    fi
	fi
}
