# Tmux helper functions for zsh

# Start or switch to a tmux dev session
# Uses .tmux-session.sh in current dir, falls back to ~/.tmux-session.sh
dev() {
    local session_name=${1:-$(basename "$PWD")}
    local project_dir=${2:-$PWD}

    # Helper to attach or switch based on context
    _tmux_goto() {
        if [[ -n "$TMUX" ]]; then
            tmux switch-client -t "$1"
        else
            tmux attach -t "$1"
        fi
    }

    # If session exists, just go to it
    if tmux has-session -t "$session_name" 2>/dev/null; then
        _tmux_goto "$session_name"
        return
    fi

    # Find session script: local override or default
    local session_script=""
    if [[ -f "$project_dir/.tmux-session.sh" ]]; then
        session_script="$project_dir/.tmux-session.sh"
    elif [[ -f ~/.tmux-session.sh ]]; then
        session_script=~/.tmux-session.sh
    fi

    # Run session script or create basic session
    if [[ -n "$session_script" ]]; then
        SESSION_NAME="$session_name" PROJECT_DIR="$project_dir" source "$session_script"
    else
        tmux new-session -d -s "$session_name" -c "$project_dir"
        _tmux_goto "$session_name"
    fi
}

# Kill a tmux session using fzf picker
devkill() {
    local session
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Kill session: ")
    [[ -n "$session" ]] && tmux kill-session -t "$session"
}
