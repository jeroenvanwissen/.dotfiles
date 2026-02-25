#!/bin/bash
set -e

echo "🚀 Starting Linux setup..."

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

# ── Detect package manager ──────────────────────────────────────────
if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    pkg_update()  { sudo apt update && sudo apt upgrade -y; }
    pkg_install() { sudo apt install -y "$@"; }
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    pkg_update()  { sudo dnf upgrade --refresh -y; }
    pkg_install() { sudo dnf install -y "$@"; }
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    pkg_update()  { sudo pacman -Syu --noconfirm; }
    pkg_install() { sudo pacman -S --noconfirm --needed "$@"; }
else
    echo "❌ Unsupported package manager. Install packages manually."
    exit 1
fi

echo "📦 Detected package manager: $PKG_MANAGER"

# ── Update system packages ──────────────────────────────────────────
echo "📦 Updating system packages..."
pkg_update

# ── Base dependencies ───────────────────────────────────────────────
echo "📦 Installing base dependencies..."
case "$PKG_MANAGER" in
    apt)
        pkg_install \
            curl wget git build-essential pkg-config \
            python3 python3-venv pipx \
            fzf bat fd-find ripgrep unzip
        # Symlink bat / fd if installed under alternate names
        [ ! -e ~/.local/bin/bat ] && [ -x /usr/bin/batcat ] && ln -sf /usr/bin/batcat ~/.local/bin/bat
        [ ! -e ~/.local/bin/fd ] && [ -x /usr/bin/fdfind ] && ln -sf /usr/bin/fdfind ~/.local/bin/fd
        ;;
    dnf)
        pkg_install \
            curl wget git gcc gcc-c++ make pkg-config \
            python3 python3-pip pipx \
            fzf bat fd-find ripgrep unzip
        ;;
    pacman)
        pkg_install \
            curl wget git base-devel pkg-config \
            python python-pipx \
            fzf bat fd ripgrep unzip
        ;;
esac

# Create necessary directories
echo "📁 Creating config directories..."
mkdir -p ~/.config/{ghostty,helix,yazi,opencode}
mkdir -p ~/.local/bin

# ── ZSH + Oh My ZSH ────────────────────────────────────────────────
echo "📦 Installing ZSH..."
if ! command -v zsh &>/dev/null; then
    pkg_install zsh
fi

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
    echo "🐚 Setting ZSH as default shell..."
    chsh -s "$ZSH_PATH"
else
    echo "✅ ZSH is already the default shell"
fi

echo "🔗 Creating ZSH symlinks..."
backup_if_exists ~/.zshrc
backup_if_exists ~/.zprofile
ln -sf "$PWD/config/zsh/.zshrc" ~/
ln -sf "$PWD/config/zsh/.zprofile" ~/

# ── NVM + Node.js ──────────────────────────────────────────────────
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

# Ensure pipx is on PATH
echo "📥 Configuring pipx..."
pipx ensurepath

# ── GH CLI ──────────────────────────────────────────────────────────
echo "📦 Installing GH CLI..."
if ! command -v gh &>/dev/null; then
    echo "📥 Installing GH CLI..."
    case "$PKG_MANAGER" in
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
                | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
            sudo apt update && sudo apt install -y gh
            ;;
        dnf)
            sudo dnf install -y 'dnf-command(config-manager)'
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            sudo dnf install -y gh
            ;;
        pacman)
            pkg_install github-cli
            ;;
    esac
else
    echo "✅ GH CLI already installed"
fi

# ── Helix ───────────────────────────────────────────────────────────
echo "📦 Installing Helix..."
if ! command -v hx &>/dev/null; then
    echo "📥 Installing Helix..."
    case "$PKG_MANAGER" in
        apt)
            sudo add-apt-repository -y ppa:maveonair/helix-editor
            sudo apt update && sudo apt install -y helix
            ;;
        dnf)
            sudo dnf copr enable -y varlad/helix
            sudo dnf install -y helix
            ;;
        pacman)
            pkg_install helix
            ;;
    esac
else
    echo "✅ Helix already installed"
fi

# ── Language Servers ────────────────────────────────────────────────
echo "📥 Installing Language Servers..."
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted
npm install -g bash-language-server
npm install -g yaml-language-server
npm install -g pyright

# TOML language server (taplo)
if ! command -v taplo &>/dev/null; then
    echo "📥 Installing taplo..."
    cargo install --locked taplo-cli 2>/dev/null || echo "⚠️  Install taplo manually (requires cargo)"
fi

# Python language servers
pipx install 'python-lsp-server[all]' 2>/dev/null || pipx upgrade 'python-lsp-server[all]'
pipx install ruff 2>/dev/null || pipx upgrade ruff
pipx install jedi-language-server 2>/dev/null || pipx upgrade jedi-language-server

# Markdown language server
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  MARKSMAN_ARCH="marksman-linux-x64" ;;
    aarch64) MARKSMAN_ARCH="marksman-linux-arm64" ;;
    *)       MARKSMAN_ARCH="" ;;
esac
if [ -n "$MARKSMAN_ARCH" ]; then
    curl -Lo ~/.local/bin/marksman "https://github.com/artempyanykh/marksman/releases/latest/download/$MARKSMAN_ARCH"
    chmod +x ~/.local/bin/marksman
else
    echo "⚠️  Unsupported architecture for marksman: $ARCH"
fi

echo "🔗 Creating Helix symlinks..."
ln -sf "$PWD/config/helix/config.toml" ~/.config/helix/
ln -sf "$PWD/config/helix/languages.toml" ~/.config/helix/

# ── Ghostty ─────────────────────────────────────────────────────────────────
echo "📦 Installing Ghostty..."
if ! command -v ghostty &>/dev/null; then
    echo "📝 Ghostty must be installed manually on Linux."
    echo "   See: https://ghostty.org/docs/install/binary"
else
    echo "✅ Ghostty already installed"
fi
echo "🔗 Creating Ghostty symlinks..."
ln -sf "$PWD/config/ghostty/config" ~/.config/ghostty/
ln -sf "$PWD/config/ghostty/themes" ~/.config/ghostty/

# ── Starship ────────────────────────────────────────────────────────
echo "📦 Installing Starship..."
if ! command -v starship &>/dev/null; then
    echo "📥 Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "✅ Starship already installed"
fi
echo "🔗 Creating Starship symlinks..."
ln -sf "$PWD/config/starship.toml" ~/.config/

# ── Modern CLI tools ───────────────────────────────────────────────
echo "📦 Installing modern CLI tools..."

# eza
if ! command -v eza &>/dev/null; then
    echo "📥 Installing eza..."
    case "$PKG_MANAGER" in
        apt)
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo apt update && sudo apt install -y eza
            ;;
        dnf)
            sudo dnf install -y eza
            ;;
        pacman)
            pkg_install eza
            ;;
    esac
else
    echo "✅ eza already installed"
fi

# zoxide
if ! command -v zoxide &>/dev/null; then
    echo "📥 Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "✅ zoxide already installed"
fi

# ── Yazi ────────────────────────────────────────────────────────────
echo "📦 Installing Yazi..."
if ! command -v yazi &>/dev/null; then
    echo "📥 Installing Yazi..."
    cargo install --locked yazi-fm yazi-cli 2>/dev/null || echo "⚠️  Install yazi manually (requires cargo or download from GitHub releases)"
else
    echo "✅ Yazi already installed"
fi
echo "🔗 Creating Yazi symlinks..."
ln -sf "$PWD/config/yazi" ~/.config/

# Install Yazi plugins
echo "📦 Installing Yazi plugins..."
if command -v ya &>/dev/null; then
    ya pkg install
fi

# ── git-delta ───────────────────────────────────────────────────────
echo "📦 Installing git-delta..."
if ! command -v delta &>/dev/null; then
    echo "📥 Installing git-delta..."
    cargo install --locked git-delta 2>/dev/null || echo "⚠️  Install git-delta manually (requires cargo or download from GitHub releases)"
else
    echo "✅ git-delta already installed"
fi

# ── lazygit ─────────────────────────────────────────────────────────
echo "📦 Installing lazygit..."
if ! command -v lazygit &>/dev/null; then
    echo "📥 Installing lazygit..."
    case "$PKG_MANAGER" in
        pacman)
            pkg_install lazygit
            ;;
        *)
            LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            ARCH=$(uname -m)
            case "$ARCH" in
                x86_64)  LG_ARCH="x86_64" ;;
                aarch64) LG_ARCH="arm64" ;;
                *)       LG_ARCH="$ARCH" ;;
            esac
            curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"
            tar xf /tmp/lazygit.tar.gz -C ~/.local/bin lazygit
            rm /tmp/lazygit.tar.gz
            ;;
    esac
else
    echo "✅ lazygit already installed"
fi

# ── OpenCode ────────────────────────────────────────────────────────
echo "📦 Installing OpenCode..."
if ! command -v opencode &>/dev/null; then
    echo "📥 Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
else
    echo "✅ OpenCode already installed"
fi
echo "🔗 Creating OpenCode config symlinks..."
mkdir -p ~/.config/opencode
ln -sf "$PWD/config/opencode/opencode.json" ~/.config/opencode/

# ── Git config ──────────────────────────────────────────────────────
echo "🔗 Creating Git config symlinks..."
backup_if_exists ~/.gitconfig
ln -sf "$PWD/config/git/.gitconfig" ~/
ln -sf "$PWD/config/git/.gitignore_global" ~/

# ── Custom scripts ──────────────────────────────────────────────────
echo "🔗 Creating script symlinks..."
ln -sf "$PWD/bin/update-tools" ~/.local/bin/

echo "✨ Installation complete! Please restart your terminal."
