#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# ---------------------------------------------------------------------------
# Extract fields from JSON
# ---------------------------------------------------------------------------
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name // empty')

agent_name=$(echo "$input" | jq -r '.agent.name // empty')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // empty')
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# ---------------------------------------------------------------------------
# Section 1: Working directory (basename only, blue)
# ---------------------------------------------------------------------------
dir_basename=$(basename "$cwd")
printf '\033[34m%s\033[0m' "$dir_basename"

# ---------------------------------------------------------------------------
# Section 2: Git branch + status indicators
# ---------------------------------------------------------------------------
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    # Bare repos are worktree layout roots — show "bare" as the branch label
    if [[ "$(git -C "$cwd" rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then
        printf ' on \033[35mbare\033[0m'
    else
        # Prefer worktree branch from JSON (already resolved by Claude Code)
        if [[ -n "$worktree_branch" ]]; then
            branch="$worktree_branch"
        else
            branch=$(git -C "$cwd" branch --no-optional-locks 2>/dev/null | sed -n 's/^\* //p')
        fi

        if [[ -n "$branch" ]]; then
            printf ' on \033[35m%s\033[0m' "$branch"
        fi

        # Uncommitted changes (yellow asterisk)
        if [[ -n $(git -C "$cwd" status --porcelain --no-optional-locks 2>/dev/null) ]]; then
            printf '\033[33m*\033[0m'
        fi

        # Unpushed commits (green up arrow + count)
        ahead=$(git -C "$cwd" rev-list --no-optional-locks --count @{u}..HEAD 2>/dev/null || echo 0)
        if [[ "$ahead" -gt 0 ]]; then
            printf '\033[32m↑%s\033[0m' "$ahead"
        fi

        # Unpulled commits (red down arrow + count)
        behind=$(git -C "$cwd" rev-list --no-optional-locks --count HEAD..@{u} 2>/dev/null || echo 0)
        if [[ "$behind" -gt 0 ]]; then
            printf '\033[31m↓%s\033[0m' "$behind"
        fi

        # Stashed changes (blue equivalence symbol)
        if git -C "$cwd" rev-parse --no-optional-locks --verify refs/stash >/dev/null 2>&1; then
            printf '\033[34m≡\033[0m'
        fi
    fi
fi

# ---------------------------------------------------------------------------
# Section 3: Model name + context usage (e.g. "Opus (8% of 1M)")
# ---------------------------------------------------------------------------
if [[ -n "$model" ]]; then
    ctx_label=""
    if [[ -n "$context_pct" && -n "$context_size" ]]; then
        ctx_int=${context_pct%.*}
        if [[ "$context_size" -ge 1000000 ]]; then
            size_label="$((context_size / 1000000))M"
        elif [[ "$context_size" -ge 1000 ]]; then
            size_label="$((context_size / 1000))k"
        else
            size_label="$context_size"
        fi
        if [[ "$ctx_int" -ge 80 ]]; then
            ctx_color='\033[31m'
        elif [[ "$ctx_int" -ge 50 ]]; then
            ctx_color='\033[33m'
        else
            ctx_color='\033[32m'
        fi
        ctx_label=$(printf " | ${ctx_color}%d%%\033[2m of %s" "$ctx_int" "$size_label")
    fi
    printf ' | \033[2m%s%s\033[0m' "$model" "$ctx_label"
fi

# ---------------------------------------------------------------------------
# Section 5: Agent name (cyan, only when running with --agent)
# ---------------------------------------------------------------------------
if [[ -n "$agent_name" ]]; then
    printf ' | \033[36magent:%s\033[0m' "$agent_name"
fi
