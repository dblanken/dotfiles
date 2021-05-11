if which dircolors &>/dev/null; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
elif which gdircolors &>/dev/null; then
  if [ -r ~/.dircolors ]; then
    eval "$(gdircolors -b ~/.dircolors)"
  else
    eval "$(gdircolors -b)"
  fi
fi
