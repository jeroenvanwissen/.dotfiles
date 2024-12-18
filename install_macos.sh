#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting macOS setup..."

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

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p ~/.config/{kitty,fish,helix,tmux}
mkdir -p ~/.local/bin

# Install and configure Kitty
echo "📦 Installing Kitty..."
if brew list kitty &>/dev/null; then
    echo "✅ Kitty already installed"
else
    echo "📥 Installing Kitty..."
    brew install kitty
fi
echo "🔗 Creating Kitty symlinks..."
ln -sf $PWD/config/kitty/kitty.conf ~/.config/kitty/
ln -sf $PWD/config/kitty/current-theme.conf ~/.config/kitty/

# Install and configure Helix
echo "📦 Installing Helix and its dependencies..."
if brew list helix &>/dev/null; then
    echo "✅ Helix already installed"
else
    echo "📥 Installing Helix..."
    brew install helix
fi

# Install fnm (Fast Node Manager)
echo "📦 Installing fnm..."
if brew list fnm &>/dev/null; then
    echo "✅ fnm already installed"
else
    echo "📥 Installing fnm..."
    brew install fnm
fi

# Install Python and pipx for Python language servers
if ! command -v python3 &> /dev/null; then
    echo "📥 Installing Python..."
    brew install python
fi

if ! command -v pipx &> /dev/null; then
    echo "📥 Installing pipx..."
    brew install pipx
    pipx ensurepath
fi

echo "📥 Installing Language Servers..."
# JavaScript/TypeScript language servers
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted # Provides HTML, CSS, and ESLint servers

# Bash language server
npm install -g bash-language-server

# Python language servers
pipx install 'python-lsp-server[all]' # pylsp
pipx install ruff-lsp # ruff
pipx install jedi-language-server # jedi
npm install -g pyright # pyright

# Markdown language server
brew install marksman

echo "🔗 Creating Helix symlinks..."
ln -sf $PWD/config/helix/config.toml ~/.config/helix/
ln -sf $PWD/config/helix/languages.toml ~/.config/helix/

# Install and configure Tmux
echo "📦 Installing Tmux..."
if brew list tmux &>/dev/null; then
    echo "✅ Tmux already installed"
else
    echo "📥 Installing Tmux..."
    brew install tmux
fi
echo "🔗 Creating Tmux symlinks..."
ln -sf $PWD/config/tmux/.tmux.conf ~/

# Install and configure Fish
echo "📦 Installing Fish..."
if brew list fish &>/dev/null; then
    echo "✅ Fish already installed"
else
    echo "📥 Installing Fish..."
    brew install fish
fi

# Set up fish as default shell if it isn't already
FISH_PATH=$(which fish)
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "🐟 Adding Fish to allowed shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [[ $SHELL != "$FISH_PATH" ]]; then
    echo "🐟 Setting Fish as default shell..."
    chsh -s "$FISH_PATH"
fi

# Install Oh My Fish
echo "🎣 Installing Oh My Fish..."
if ! command -v omf &> /dev/null; then
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > omf-install
    fish omf-install --noninteractive --yes
    rm omf-install
fi

# Install Fisher
echo "🎣 Installing Fisher..."
if ! fish -c "functions -q fisher" &> /dev/null; then
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
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

# Set up custom scripts
echo "🔗 Creating script symlinks..."
ln -sf $PWD/bin/spotify-status ~/.local/bin/

echo "✨ Installation complete! Please restart your terminal and run 'fish' to start using your new setup."
