#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Ubuntu WSL setup..."

# Update package list and upgrade existing packages
echo "📦 Updating package lists..."
sudo apt update && sudo apt upgrade -y

# Install required base packages
echo "📦 Installing base dependencies..."
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    build-essential \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p ~/.config/{fish,helix,tmux}
mkdir -p ~/.local/bin

# Install and configure GH CLI
echo "📦 Installing GH CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
fi

# Install and configure Helix
echo "📦 Installing Helix..."
if ! command -v hx &> /dev/null; then
    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update
    sudo apt install -y helix
fi

# Install fnm (Fast Node Manager)
echo "📦 Installing fnm..."
if ! command -v fnm &> /dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash
    export PATH="/home/$USER/.local/share/fnm:$PATH"
    eval "`fnm env`"
fi

# Initialize fnm and install Node.js
echo "🔧 Initializing fnm..."
eval "`fnm env`"
echo "📥 Installing latest LTS version of Node.js..."
fnm install --lts
fnm use lts-latest

# Install pipx
echo "📥 Installing pipx..."
sudo apt install -y pipx
pipx ensurepath

echo "📥 Installing Language Servers..."
# JavaScript/TypeScript language servers
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted

# Bash language server
npm install -g bash-language-server

# Python language servers
pipx install 'python-lsp-server[all]'
pipx install ruff-lsp
pipx install jedi-language-server
npm install -g pyright

# Install Marksman (for markdown)
MARKSMAN_VERSION=$(curl -s "https://api.github.com/repos/artempyanykh/marksman/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
curl -Lo ~/.local/bin/marksman "https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux"
chmod +x ~/.local/bin/marksman

echo "🔗 Creating Helix symlinks..."
ln -sf $PWD/config/helix/config.toml ~/.config/helix/
ln -sf $PWD/config/helix/languages.toml ~/.config/helix/

# Install and configure Tmux
echo "📦 Installing Tmux..."
sudo apt install -y tmux
echo "🔗 Creating Tmux symlinks..."
ln -sf $PWD/config/tmux/.tmux.conf ~/.config/tmux/

# Install TPM
TPM_PATH="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_PATH" ]; then
    echo "📦 Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
fi

# Install and configure Fish
echo "📦 Installing Fish..."
if ! command -v fish &> /dev/null; then
    sudo apt-add-repository ppa:fish-shell/release-3
    sudo apt update
    sudo apt install -y fish
fi

# Set up fish as default shell
FISH_PATH=$(which fish)
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "🐟 Adding Fish to allowed shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [[ $SHELL != "$FISH_PATH" ]]; then
    echo "🐟 Setting Fish as default shell..."
    chsh -s "$FISH_PATH"
fi

# Install Fisher
echo "🎣 Installing Fisher..."
if ! fish -c "functions -q fisher" &> /dev/null; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi

# Install fish plugins
echo "🔌 Installing Fish plugins..."
fish -c "fisher install budimanjojo/tmux.fish"

echo "🔗 Creating Fish symlinks..."
ln -sf $PWD/config/fish/config.fish ~/.config/fish/
ln -sf $PWD/config/fish/fish_plugins ~/.config/fish/

# Install and configure Starship
echo "🚀 Installing Starship..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
echo "🔗 Creating Starship symlinks..."
ln -sf $PWD/config/starship.toml ~/.config/

echo "✨ Installation complete! Please restart your terminal and run 'fish' to start using your new setup."