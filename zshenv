export LANG=en_US.UTF-8
export LC_TIME=en_AU.UTF-8

if [[ $(uname -s) = Darwin ]]; then
  # Override insanely low open file limits on macOS.
  ulimit -n 65536
  ulimit -u 1064
fi

