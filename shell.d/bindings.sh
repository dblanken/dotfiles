#!/usr/local/bin/bash

bind '"":"tmux2\n"'

# Search forward and backword based on what I typed
bind -m vi '"\C-j":history-substring-search-backward'
bind -m vi '"\C-k":history-substring-search-forward'
