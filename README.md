# The files behind the man (DOTFILES)

This is a curated list of dotfiles I use in my day to day work/play.

## Installation

Let me preface that...you probably shouldn't as these are curated for my own
personal preferences, but if you insist:

I use [stow](https://www.gnu.org/software/stow/) to handle these.  To start,
use:

```bash
stow */
```

The / is very important above, as it will only do directories.

## Features

* Dynamic Prompt Creation - This allows me to extend the prompt as needed
  throughout it's lifetime.  Any file placed inside .zsh will be sourced,
  which other stow directories utilize.
* ASDF - I use ASDF as my manager for all kinds of application, most notably
  Ruby.
* Ruby - I use rubocop, but I have it use the configuration of StandardRb.
* Nvim - I use neovim and nvr as my editor of choice.
* Tmux - Easy copy and paste, easy pane creation
* Hammerspoon - Easy screen real estate configuration
* Karabiner - CAPS LOCK is Escape on press, CTRL on hold
* Lynx - Vi style lynx
