# Dotfiles

My personal dotfiles for macOS and Linux development environments.

## What's Inside

- **ZSH**: Shell configuration with Oh My ZSH and Starship prompt
- **Kitty**: GPU-based terminal emulator (macOS)
- **Helix**: Modern text editor with LSP support
- **Starship**: Cross-shell prompt configuration
- **Yazi**: Terminal file manager
- **NVM**: Node.js version management with auto-switching
- **lazygit**: Terminal UI for git (integrated with Helix via Ctrl-G)
- **git-delta**: Syntax-highlighted, side-by-side diffs
- **OpenCode**: Open source AI coding agent (Catppuccin theme)

## Language Support (Helix LSPs)

| Language   | LSP / Tooling                                       |
| ---------- | --------------------------------------------------- |
| TypeScript | typescript-language-server, eslint, tailwindcss, prettier |
| Rust       | rust-analyzer, clippy                               |
| Swift      | sourcekit-lsp, swiftformat                          |
| Python     | pylsp, ruff, jedi, pyright                          |
| Astro      | astro-ls                                            |
| HTML/CSS   | vscode-langservers-extracted                        |
| TOML       | taplo                                               |
| YAML       | yaml-language-server                                |
| Bash       | bash-language-server                                |
| Markdown   | marksman                                            |

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

## Custom Scripts

Scripts in `bin/` are symlinked to `~/.local/bin/`:

- `split-kitten` — Create vertical split in Kitty
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
- **Utilities**: `lg` (lazygit), `ports`, `ip`
