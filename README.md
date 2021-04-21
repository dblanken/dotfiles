# Dotfiles

The files behind the man...

Disclaimer: These are to be stolen from, not forked...

## Features
### Dotfiles
A set of dotfiles I've been working on for almost a year now.  Characteristics include:

- Clipboard pasting.
- Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
- Italics in terminal.
- Bundles a (not-excessive) number of useful Vim plug-ins, geared toward Ruby developers.
- Relatively restrained Zsh config; Bash-like with Zsh niceties, like right side prompt, auto-cd hooks, command elapsed time printing, etc.
- Comprehensive Hammerspoon configuration

### Keyboard customization
On macOS, Karabiner-Elements is used for the following:
- Make Caps Lock serve as Escape when tapped and Left Control when chorded with another key.
- Make Return serve as Return when tapped and Right Control when chorded with another key.
- Toggle Caps Lock on by tapping both Shift keys simulatneously.

### Prompt
Zsh is configured with the following prompt:

```sh
[i] !dblanken@Raistlin new_dotfiles [master●] %                    0.04s
```

Visible above are:

- Indicator of vi-mode in the terminal
  - [i] - Insert mode
  - [n] - Normal mode
- username (red if last command returned an error code)
- hostname
- current directory
- Git version control worktree status using colors that atch those used in git status:
  - Green dot indicates staged changes.
  - Red dot indicates unstaged changes.
  - Blue dot indicates untracked files.
- Right hand prompt displays the execution time of the last command.

## Requirements

- MacOS
- [Homebrew](https://brew.sh)
- [RCM](https://github.com/thoughtbot/rcm)
- Alacritty or another true color supported terminal
- tmux 3.0 or later
- Neovim or Vim 8.0 or later
- Recent Zsh, Git

## Usage

```sh
git clone https://github.com/dblanken/dotfiles <path-to-dotfiles>
cd <path-to-dotfiles>
sh ./install.sh
```

## License
Unless otherwise noted, the contents of this repo are in the public domain.  See the [LICENSE](https://github.com/dblanken/dotfiles/blob/master/LICENSE.md) for details.

## Authors
This repo was written and maintained by David Blankenship <dtblankenship@gmail.com>.

I want to give a lot of thanks to [Greg Hurrell](https://www.youtube.com/c/GregHurrell) for sharing his experiences with Vim and configurations.
