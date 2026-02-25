#!/usr/bin/env zsh
# shellcheck shell=bash
# === Navigation ===
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# === Modern CLI replacements (with fallbacks) ===
if command -v eza &>/dev/null; then
  alias ls="eza"
  alias ll="eza -lh --git"
  alias la="eza -lah --git"
  alias tree="eza --tree"
else
  alias ll="ls -lh"
  alias la="ls -lah"
fi

if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
fi

# === Git ===
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -20"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias gpr="gh pr create"
alias gpl="git pull"
alias gsw="git switch"
alias gsc="git switch -c"

# === Docker ===
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# === Node.js / npm / pnpm ===
alias ni="npm install"
alias nr="npm run"
alias nd="npm run dev"
alias nb="npm run build"
alias nt="npm run test"
alias nx="npx"
if command -v pnpm &>/dev/null; then
  alias pi="pnpm install"
  alias pr="pnpm run"
  alias pd="pnpm dev"
  alias pb="pnpm build"
  alias pt="pnpm test"
  alias px="pnpm dlx"
fi

# === Cargo (Rust) ===
alias cr="cargo run"
alias cb="cargo build"
alias ct="cargo test"
alias cc="cargo check"
alias cw="cargo watch -x run"
alias cf="cargo fmt"
alias ccl="cargo clippy"

# === Swift ===
alias sb="swift build"
alias sr="swift run"
alias st="swift test"
alias sp="swift package"

# === OpenCode ===
alias oc="opencode"

# === Yazi (cd on exit) ===
function yy() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || return
  fi
  rm -f -- "$tmp"
}

# === General ===
alias cls="clear"
alias reload="source ~/.zshrc"
alias dotfiles="cd ~/.dotfiles && git status"
alias lg="lazygit"
alias ports="lsof -i -P -n | grep LISTEN"
alias ip="curl -s ifconfig.me"
