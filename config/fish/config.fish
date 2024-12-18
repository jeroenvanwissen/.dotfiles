eval (brew shellenv)

if status is-interactive
    and not set -q TMUX
    tmux
end

# Initialize fnm
# if test -d /opt/homebrew/bin
#     set -gx PATH /opt/homebrew/bin $PATH
# end

if type -q fnm
    # Initialize fnm with shell completions and auto-use
    fnm env --use-on-cd --shell fish | source

    # Ensure we have a default Node.js version
    if not fnm list | grep -q "default"
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
# set -U fish_user_paths $HOME/helix $fish_user_paths

function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        echo "Updated PATH: $PATH"
    else
        echo "$argv[1] not found in PATH: $PATH"
    end
end
