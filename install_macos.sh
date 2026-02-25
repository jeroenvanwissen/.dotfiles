#!/bin/bash
set -e

echo "🚀 Starting macOS setup..."

# Backup existing files before overwriting (skips symlinks for idempotent re-runs)
backup_if_exists() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup
        backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        echo "📦 Backing up $file → $backup"
        mv "$file" "$backup"
    fi
}

# Pre-flight: Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "📥 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Xcode CLT installation, then re-run this script."
    exit 1
fi

# Check for Homebrew and install if not present
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "🍺 Homebrew already installed, updating..."
    brew update
fi

# Install Homebrew packages from Brewfile
echo "📦 Installing Homebrew packages..."
brew bundle --file=$PWD/Brewfile

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p ~/.config/{kitty,ghostty,helix,yazi,opencode}
mkdir -p ~/.local/bin

# Install and configure ZSH + Oh My ZSH
echo "📦 Installing Oh My ZSH..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Installing Oh My ZSH..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My ZSH already installed"
fi

# Install ZSH plugins
echo "📦 Installing ZSH plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "✅ zsh-autosuggestions already installed"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "✅ zsh-syntax-highlighting already installed"
fi

# Set ZSH as default shell
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    ZSH_PATH=$(which zsh)
    # Ensure Homebrew zsh is in /etc/shells (required by chsh)
    if ! grep -qxF "$ZSH_PATH" /etc/shells; then
        echo "📝 Adding $ZSH_PATH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    echo "🐚 Setting ZSH as default shell..."
    chsh -s "$ZSH_PATH"
else
    echo "✅ ZSH is already the default shell"
fi

echo "🔗 Creating ZSH symlinks..."
backup_if_exists ~/.zshrc
backup_if_exists ~/.zprofile
ln -sf $PWD/config/zsh/.zshrc ~/
ln -sf $PWD/config/zsh/.zprofile ~/

# Install NVM + Node.js
echo "📦 Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    echo "📥 Installing NVM (latest)..."
    NVM_VERSION=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
else
    echo "✅ NVM already installed"
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
echo "📥 Installing Node.js LTS..."
nvm install --lts

# Python and pipx are installed via Brewfile
if ! command -v pipx &> /dev/null; then
    pipx ensurepath
fi

# GH CLI is installed via Brewfile

# Kitty is installed via Brewfile
echo "🔗 Creating Kitty symlinks..."
ln -sf $PWD/config/kitty/kitty.conf ~/.config/kitty/
ln -sf $PWD/config/kitty/current-theme.conf ~/.config/kitty/

# Ghostty is installed via Brewfile
echo "🔗 Creating Ghostty symlinks..."
ln -sf $PWD/config/ghostty/config ~/.config/ghostty/
ln -sf $PWD/config/ghostty/themes ~/.config/ghostty/

# Helix is installed via Brewfile

echo "📥 Installing Language Servers..."
# JavaScript/TypeScript language servers
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted

# Bash language server
npm install -g bash-language-server

# YAML language server
npm install -g yaml-language-server

# Python language servers
pipx install 'python-lsp-server[all]' 2>/dev/null || pipx upgrade 'python-lsp-server[all]'
pipx install ruff 2>/dev/null || pipx upgrade ruff
pipx install jedi-language-server 2>/dev/null || pipx upgrade jedi-language-server
npm install -g pyright

# Marksman, rust-analyzer, taplo are installed via Brewfile

echo "🔗 Creating Helix symlinks..."
ln -sf $PWD/config/helix/config.toml ~/.config/helix/
ln -sf $PWD/config/helix/languages.toml ~/.config/helix/

# Starship is installed via Brewfile
echo "🔗 Creating Starship symlinks..."
ln -sf $PWD/config/starship.toml ~/.config/

# Yazi is installed via Brewfile
echo "🔗 Creating Yazi symlinks..."
ln -sf $PWD/config/yazi ~/.config/

# Install Yazi plugins
echo "📦 Installing Yazi plugins..."
if command -v ya &>/dev/null; then
    ya pkg install
fi

# OpenCode is installed via Brewfile
echo "🔗 Creating OpenCode config symlinks..."
mkdir -p ~/.config/opencode
ln -sf $PWD/config/opencode/opencode.json ~/.config/opencode/

# Git config
echo "🔗 Creating Git config symlinks..."
backup_if_exists ~/.gitconfig
ln -sf $PWD/config/git/.gitconfig ~/
ln -sf $PWD/config/git/.gitignore_global ~/

# Set up custom scripts
echo "🔗 Creating script symlinks..."
ln -sf $PWD/bin/split-kitten ~/.local/bin/
ln -sf $PWD/bin/update-tools ~/.local/bin/

echo "✨ Installation complete! Please restart your terminal."
