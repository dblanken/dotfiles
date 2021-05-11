function nvim
  if begin; set -q NVIM_LISTEN_ADDRESS; end
    nvr $argv
  else
    command nvim $argv
  end
end
