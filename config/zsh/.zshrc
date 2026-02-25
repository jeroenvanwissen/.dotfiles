#!/usr/bin/env zsh
# shellcheck shell=bash
# === Oh My ZSH ===
export ZSH="$HOME/.oh-my-zsh"
export plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)
# shellcheck source=/dev/null
source $ZSH/oh-my-zsh.sh

# === Starship Prompt ===
eval "$(starship init zsh)"

# === PATH ===
export PATH="$HOME/.local/bin:$PATH"

# === NVM ===
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-switch Node version when entering a directory with .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version
  node_version="$(nvm version)"
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# === Python (auto-detect latest Homebrew Python) ===
if [ -d "/opt/homebrew/opt/python/libexec/bin" ]; then
  export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
fi

# === Rust ===
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# === Deno ===
if [ -d "$HOME/.deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# === Bun ===
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -d "$HOME/.bun" ] && export PATH="$HOME/.bun/bin:$PATH"

# === Java / Android (uncomment if needed) ===
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
# export ANDROID_HOME="$HOME/Library/Android/sdk"
# export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# === Aliases ===
# shellcheck source=/dev/null
[ -f "$HOME/.dotfiles/config/zsh/aliases.zsh" ] && source "$HOME/.dotfiles/config/zsh/aliases.zsh"

# === Zoxide ===
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# === OrbStack ===
# shellcheck source=/dev/null
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# pnpm
export PNPM_HOME="/Users/jeroen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
