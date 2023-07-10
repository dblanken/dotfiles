cc() { cd "$1/$2" && ls -d */; }

_cc() {
  local curcontext=$curcontext state state_descr line
  typeset -A opt_args

  _arguments -C \
    ':directory under ~/code/:_path_files -W ~/code -/' \
    ':subdirectory:_files -W ~/code/${words[2]}/ -/' && return 0
}

compdef _cc cc
