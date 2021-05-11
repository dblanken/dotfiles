# I like saving some keystrokes
# If I cd, I ls
function cd {
  builtin cd "$@" && ls -F
}
