# Default tmux session layout
# Override per-project by creating .tmux-session.sh in project root
#
# Available variables:
#   SESSION_NAME - name of the session
#   PROJECT_DIR  - path to the project directory

# Window 1: NeoVim + Claude Code side by side
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR" -n dev
tmux split-window -h -t "$SESSION_NAME:dev" -c "$PROJECT_DIR"
sleep 0.1
tmux send-keys -t "$SESSION_NAME:dev.1" 'nvim .' C-m
tmux send-keys -t "$SESSION_NAME:dev.2" 'claude' C-m
tmux select-pane -t "$SESSION_NAME:dev.1"

# Window 2: Shell for misc commands
tmux new-window -t "$SESSION_NAME" -n shell -c "$PROJECT_DIR"

# Window 3: Server/processes
tmux new-window -t "$SESSION_NAME" -n server -c "$PROJECT_DIR"

tmux select-window -t "$SESSION_NAME:1"

# Switch if inside tmux, attach if outside
if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach -t "$SESSION_NAME"
fi
