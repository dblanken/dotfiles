#!/bin/sh

if [ -f /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
elif [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
else
  echo "I did not detect an asdf instance."
fi
