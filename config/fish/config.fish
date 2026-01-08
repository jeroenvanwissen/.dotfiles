# Figuring out where we have installed Homebrew
if test -d /opt/homebrew/bin
    set -gx PATH /opt/homebrew/bin $PATH
    # set -Ua fish_user_paths /opt/homebrew/lib/ruby/gems/3.4.0/bin
else if test -d /usr/local/bin
    set -gx PATH /usr/local/bin $PATH
end

# Initialize Homebrew environment if available
if command -v brew >/dev/null 2>&1
    eval (brew shellenv)
end

# Auto-start tmux for interactive sessions, but not in VSCode or if already in tmux
if status is-interactive
    and not set -q TMUX
    and not set -q VSCODE_INJECTION
    and test "$TERM_PROGRAM" != "vscode"
    tmux
end

if type -q fnm
    # Initialize fnm with shell completions and auto-use
    fnm env --use-on-cd --shell fish | source

    # Ensure we have a default Node.js version
    if not fnm list | grep -q default
        fnm install --lts
        fnm default (fnm list | grep "lts" | head -n1)
    end

    # nvm compatibility functions
    function nvm
        fnm $argv
    end

    function nvm.use
        fnm use $argv
    end

    function nvm.install
        fnm install $argv
    end

    function nvm.ls
        fnm list $argv
    end

    function nvm.list
        fnm list $argv
    end

    function nvm.default
        fnm default $argv
    end
end

alias ll="ls -lh"
starship init fish | source
echo "🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄"

set -U fish_user_paths $HOME/.local/bin $fish_user_paths

function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        echo "Updated PATH: $PATH"
    else
        echo "$argv[1] not found in PATH: $PATH"
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :
