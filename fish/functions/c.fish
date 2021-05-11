function c
  if count $argv > /dev/null
    cd $HOME/code/$argv
  else
    cd $HOME/code
  end
end
# complete --exclusive --command c --arguments "(ls -l $HOME/code | grep '^d' | awk '{print $NF}')"
complete --exclusive --command c --arguments '(__dir_only_fish_complete_directories ~/code/)'
