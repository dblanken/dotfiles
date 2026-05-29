# yalesites-worktrees.zsh — Tab completion for the yw workspace manager

_yw_workspace_names() {
  local worktrees_dir="${YW_WORKTREES_DIR:-$HOME/code/yalesites-worktrees}"
  [[ -d "$worktrees_dir" ]] || return
  local -a names
  for ws in "$worktrees_dir"/*/; do
    [[ -f "${ws}.workspace" ]] && names+=("$(basename "${ws%/}")")
  done
  echo "${names[@]}"
}

_yw() {
  local state
  local -a commands=(
    'new:Create a new isolated workspace'
    'list:List all workspaces'
    'status:Show git status across repos in a workspace'
    'activate:Start Lando for a workspace'
    'deactivate:Stop Lando for a workspace'
    'rm:Remove a workspace'
    'help:Show usage information'
  )

  _arguments \
    '1:command:->command' \
    '*::args:->args'

  case $state in
    command)
      _describe 'yw command' commands
      ;;
    args)
      local cmd="${words[1]}"
      case "$cmd" in
        status|activate|deactivate|rm|remove)
          local -a workspaces
          IFS=' ' read -rA workspaces <<< "$(_yw_workspace_names)"
          _describe 'workspace' workspaces
          ;;
        new)
          _arguments \
            '(-b --branch)'{-b,--branch}'[Branch to check out]:branch:' \
            '(-c --create)'{-c,--create}'[Create branch from develop if missing]' \
            ':workspace name:'
          ;;
      esac
      ;;
  esac
}

compdef _yw yw
