#!/bin/bash
set -e

echo "🧹 Cleaning up unused tools..."

# ── Fish shell ──────────────────────────────────────────────────────
if command -v fish &>/dev/null; then
    echo "🐟 Removing Fish shell..."

    # Reset default shell to zsh if fish is current default
    if [[ "$SHELL" == *"fish"* ]]; then
        echo "  ↳ Resetting default shell to zsh..."
        chsh -s "$(which zsh)"
    fi

    # Remove Fisher and fish plugins
    if [ -d "$HOME/.config/fish/functions" ]; then
        echo "  ↳ Removing Fish config..."
    fi
    rm -rf "$HOME/.config/fish"

    # Uninstall via Homebrew (macOS) or package manager (Linux)
    if command -v brew &>/dev/null && brew list fish &>/dev/null; then
        echo "  ↳ Uninstalling Fish via Homebrew..."
        brew uninstall fish
    elif command -v apt &>/dev/null; then
        echo "  ↳ Uninstalling Fish via apt..."
        sudo apt remove -y fish
    elif command -v dnf &>/dev/null; then
        echo "  ↳ Uninstalling Fish via dnf..."
        sudo dnf remove -y fish
    elif command -v pacman &>/dev/null; then
        echo "  ↳ Uninstalling Fish via pacman..."
        sudo pacman -Rns --noconfirm fish
    fi

    # Remove fish from /etc/shells if present
    FISH_PATH=$(command -v fish 2>/dev/null || true)
    if [ -n "$FISH_PATH" ] && grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "  ↳ Removing Fish from /etc/shells..."
        sudo sed -i.bak "\|$FISH_PATH|d" /etc/shells
    fi

    echo "  ✅ Fish removed"
else
    echo "✅ Fish not installed, skipping"
fi

# ── Tmux ────────────────────────────────────────────────────────────
if command -v tmux &>/dev/null; then
    echo "📺 Removing Tmux..."

    # Kill any running tmux sessions
    tmux kill-server 2>/dev/null || true

    # Remove TPM and plugins
    if [ -d "$HOME/.tmux" ]; then
        echo "  ↳ Removing TPM and tmux plugins..."
        rm -rf "$HOME/.tmux"
    fi

    # Remove tmux config
    rm -f "$HOME/.tmux.conf"
    rm -rf "$HOME/.config/tmux"

    # Uninstall
    if command -v brew &>/dev/null && brew list tmux &>/dev/null; then
        echo "  ↳ Uninstalling Tmux via Homebrew..."
        brew uninstall tmux
    elif command -v apt &>/dev/null; then
        echo "  ↳ Uninstalling Tmux via apt..."
        sudo apt remove -y tmux
    elif command -v dnf &>/dev/null; then
        echo "  ↳ Uninstalling Tmux via dnf..."
        sudo dnf remove -y tmux
    elif command -v pacman &>/dev/null; then
        echo "  ↳ Uninstalling Tmux via pacman..."
        sudo pacman -Rns --noconfirm tmux
    fi

    echo "  ✅ Tmux removed"
else
    echo "✅ Tmux not installed, skipping"
fi

# ── fnm (replaced by NVM) ──────────────────────────────────────────
if command -v fnm &>/dev/null; then
    echo "📦 Removing fnm..."

    # Remove fnm data directory
    rm -rf "$HOME/.local/share/fnm"
    rm -rf "$HOME/.fnm"

    # Uninstall
    if command -v brew &>/dev/null && brew list fnm &>/dev/null; then
        echo "  ↳ Uninstalling fnm via Homebrew..."
        brew uninstall fnm
    fi

    echo "  ✅ fnm removed"
else
    echo "✅ fnm not installed, skipping"
fi

# ── Kitty (replaced by Ghostty) ─────────────────────────────────────
if command -v kitty &>/dev/null; then
    echo "🐱 Removing Kitty..."

    rm -rf "$HOME/.config/kitty"

    if command -v brew &>/dev/null && brew list --cask kitty &>/dev/null; then
        echo "  ↳ Uninstalling Kitty via Homebrew..."
        brew uninstall --cask kitty
    fi

    echo "  ✅ Kitty removed"
else
    echo "✅ Kitty not installed, skipping"
fi

# ── Helix ───────────────────────────────────────────────────────────
if command -v hx &>/dev/null || command -v helix &>/dev/null; then
    echo "🧬 Removing Helix..."

    rm -rf "$HOME/.config/helix"

    if command -v brew &>/dev/null && brew list helix &>/dev/null; then
        echo "  ↳ Uninstalling Helix via Homebrew..."
        brew uninstall helix
    elif command -v apt &>/dev/null; then
        echo "  ↳ Uninstalling Helix via apt..."
        sudo apt remove -y helix
    elif command -v dnf &>/dev/null; then
        echo "  ↳ Uninstalling Helix via dnf..."
        sudo dnf remove -y helix
    elif command -v pacman &>/dev/null; then
        echo "  ↳ Uninstalling Helix via pacman..."
        sudo pacman -Rns --noconfirm helix
    fi

    echo "  ✅ Helix removed"
else
    echo "✅ Helix not installed, skipping"
fi

# ── Midnight Commander (if leftover from older branch) ──────────────
if command -v mc &>/dev/null; then
    echo "📂 Removing Midnight Commander..."

    rm -rf "$HOME/.config/mc"
    rm -rf "$HOME/.local/share/mc"

    if command -v brew &>/dev/null && brew list mc &>/dev/null; then
        echo "  ↳ Uninstalling mc via Homebrew..."
        brew uninstall mc
    elif command -v apt &>/dev/null; then
        sudo apt remove -y mc
    elif command -v dnf &>/dev/null; then
        sudo dnf remove -y mc
    elif command -v pacman &>/dev/null; then
        sudo pacman -Rns --noconfirm mc
    fi

    echo "  ✅ Midnight Commander removed"
else
    echo "✅ Midnight Commander not installed, skipping"
fi

# ── Cleanup leftover config directories and scripts ─────────────────
echo "🗂  Cleaning leftover config directories..."
for dir in fish tmux mc kitty helix; do
    if [ -d "$HOME/.config/$dir" ]; then
        echo "  ↳ Removing ~/.config/$dir"
        rm -rf "$HOME/.config/$dir"
    fi
done
rm -f "$HOME/.local/bin/split-kitten"

echo ""
echo "✨ Cleanup complete! Restart your terminal for changes to take effect."
