# Mise Package

Configuration for [mise](https://mise.jdx.dev/) (formerly rtx/asdf alternative), a polyglot runtime version manager.

## Contents

- **config.toml** - Global mise configuration for runtime versions

## Current Configuration

```toml
[tools]
node = "latest"
```

This ensures the latest stable Node.js version is installed and available globally.

## Installation

```bash
make stow-mise
```

This will symlink `config.toml` to `~/.config/mise/config.toml`.

## Usage

Mise will automatically:
- Install the specified Node.js version on first run
- Manage PATH to include the active Node version
- Allow per-project version overrides via `.mise.toml` or `.tool-versions` files

### Common Commands

```bash
mise install           # Install all tools from config
mise use node@20       # Change Node version
mise list              # Show installed versions
mise current           # Show active versions
mise upgrade           # Upgrade mise itself
```

## Customization

Add more runtime versions to `config.toml`:

```toml
[tools]
node = "latest"
python = "3.11"
ruby = "3.2"
```

After editing, run:
```bash
mise install
```

## Shell Integration

Mise is automatically activated in zsh via the configuration in `zsh/.config/zsh/rc.d/env.zsh`:

```bash
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
```

## Platform Compatibility

**Cross-platform** - Works on both macOS and Linux.

### Installation

- **macOS**: `brew install mise` (included in Brewfile)
- **Linux**: Run `./install-linux-extras.sh --mise` or install manually:
  ```bash
  curl https://mise.run | sh
  ```

## Migration from asdf

If migrating from asdf, mise can read `.tool-versions` files automatically. Your existing asdf plugins will work with mise.

To convert asdf config to mise:
```bash
mise use --global node@$(asdf current node | awk '{print $2}')
```

## More Information

- Official docs: https://mise.jdx.dev/
- GitHub: https://github.com/jdx/mise
