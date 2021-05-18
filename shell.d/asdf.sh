#!/bin/sh

if [ -f /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
elif [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
elif [ -f /usr/share/rvm/scripts/rvm ]; then
  source /usr/share/rvm/scripts/rvm
else
  echo "I did not detect an asdf instance."
fi
