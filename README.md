# Dotfiles

The files behind the man...

Disclaimer: These are to be stolen from, not forked...

## Features
### Dotfiles
A set of dotfiles I've been working on for almost a year now.  Characteristics include:

- Clipboard pasting.
- Full mouse support (pane/split resizing, scrolling, text selection) in Vim and tmux.
- Bundles a (not-excessive) number of useful Vim plug-ins, geared toward Ruby developers.
- Relatively restrained Bash config; has CDPATH to scripts and ~/code, command elapsed time printing, etc.
- Comprehensive Hammerspoon configuration
- Vi-like lynx experience

### Keyboard customization
On macOS, Karabiner-Elements is used for the following:
- Make Caps Lock serve as Escape when tapped and Left Control when chorded with another key.
- Make Return serve as Return when tapped and Right Control when chorded with another key.
- Toggle Caps Lock on by tapping both Shift keys simulatneously.

### Prompt
Bash is configured with the following prompt:

```sh
[i] !dblanken@Raistlin new_dotfiles [master●] 0.06s $
```

Visible above are:

- indicator of vi-mode in the terminal
  - [i] - Insert mode
  - [n] - Normal mode
- red ! if last command returned an error code
- username
- hostname
- current directory
- git version control worktree status using colors that atch those used in git status:
  - Green dot indicates staged changes.
  - Red dot indicates unstaged changes.
  - Blue dot indicates untracked files.
- execution time of the last command (if greater than 5s).

## Requirements

- MacOS
- [Homebrew](https://brew.sh)
- tmux 3.0 or later
- Vim 8.0 or later
- Recent Bash/Zsh, Git

## Usage

NOTE: For most out-of-the-box experience, you should clone to $HOME/code/dotfiles.
If you decide to put it elsewhere, you might need to globally replace "/code/dotfiles"

```sh
git clone https://github.com/dblanken/dotfiles <path-to-dotfiles>
cd <path-to-dotfiles>
./setup
```

## License
Unless otherwise noted, the contents of this repo are in the public domain.  See the [LICENSE](https://github.com/dblanken/dotfiles/blob/master/LICENSE.md) for details.

## Authors
This repo was written and maintained by David Blankenship <dtblankenship@gmail.com>.

I want to give a lot of thanks to [Ben Orenstein](https://github.com/r00k), [Greg Hurrell](https://www.youtube.com/c/GregHurrell), and [Rob Muhlestein](https://github.com/rwxrob) for sharing their experiences with the command line, Vim, and configurations.
