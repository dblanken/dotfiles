# Tmux autostart
if [[ -z "$TMUX" ]] ;then                              # do not allow "tmux in tmux"
  ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
  if [[ -z "$ID" ]] ;then                              # if not available create a new one
    tmux new-session
  else
    tmux attach-session -t "$ID"                       # if available, attach to it
  fi
  exit
fi
