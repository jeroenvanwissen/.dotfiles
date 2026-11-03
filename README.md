# Dotfiles

My personal dotfiles for macOS and Linux development environments.

## What's Inside

- **ZSH**: Shell configuration with Oh My ZSH and Starship prompt
- **Ghostty**: Terminal emulator (Catppuccin Mocha theme)
- **Starship**: Cross-shell prompt configuration
- **Yazi**: Terminal file manager
- **NVM**: Node.js version management with auto-switching
- **rustup**: Rust toolchain management
- **lazygit**: Terminal UI for git
- **git-delta**: Syntax-highlighted, side-by-side diffs
- **bat**: Syntax-highlighted `cat` (Catppuccin Mocha theme)
- **OpenCode**: Open source AI coding agent (Catppuccin theme)

Git uses VS Code (`code --wait`) as its editor.

## CLI Tools

| Tool        | Replaces / Purpose           |
| ----------- | ---------------------------- |
| `eza`       | `ls` with git status & icons |
| `bat`       | `cat` with syntax highlight  |
| `fd`        | `find` (faster)              |
| `ripgrep`   | `grep` (faster)              |
| `fzf`       | Fuzzy finder                 |
| `zoxide`    | `cd` with frecency           |
| `git-delta` | Git diff pager               |
| `jq`        | JSON processor               |
| `lazygit`   | Terminal git UI              |
| `hyperfine` | Benchmarking                 |
| `tokei`     | Code statistics              |
| `watchexec` | File watcher                 |
| `xcbeautify`| Xcode build output (macOS)   |
| `opencode`  | AI coding agent (terminal)   |

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/jeroenvanwissen/.dotfiles.git
cd .dotfiles

# macOS
./install_macos.sh

# Linux (Debian/Ubuntu, Fedora, Arch)
./install_linux.sh
```

## Updating

Keep all tools up to date with a single command:

```bash
update-tools
```

## Cleaning Up Old Tools

Machines set up from older versions of these dotfiles may still have Kitty,
Helix, tmux, Fish, fnm or Midnight Commander installed. Remove them and their
leftover configs with:

```bash
./cleanup_old_tools.sh
```

## Custom Scripts

Scripts in `bin/` are symlinked to `~/.local/bin/`:

- `update-tools` — Update all installed tools

## Shell Aliases

The shell config includes aliases for common workflows:

- **Git**: `gs`, `ga`, `gc`, `gp`, `gd`, `gco`, `gsw`, `gpr`, ...
- **Node.js**: `ni` (install), `nr` (run), `nd` (dev), `nb` (build), `nt` (test)
- **pnpm**: `pi`, `pr`, `pd`, `pb`, `pt` (when available)
- **Cargo**: `cr` (run), `cb` (build), `ct` (test), `cc` (check), `ccl` (clippy)
- **Swift**: `sb` (build), `sr` (run), `st` (test)
- **Docker**: `dc`, `dcu`, `dcd`, `dcl`
- **OpenCode**: `oc` (opencode)
- **Utilities**: `lg` (lazygit), `ports`, `myip`
