#-------------------------------------------------------------------------
# Zsh Options
#-------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

DISABLE_AUTO_TITLE="true"    # don't auto set the terminal title
HIST_STAMPS="yyyy-mm-dd"     # command execution time format

setopt APPEND_HISTORY        # keep history
setopt INC_APPEND_HISTORY    # update the history after execution (not end of session)
setopt SHARE_HISTORY         # share history between sessions if we have multiple going
setopt EXTENDED_HISTORY      # add timestamps to history
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS    # remove extra blank space
setopt HIST_FIND_NO_DUPS     # do not find duplicates when searching
setopt HIST_IGNORE_SPACE     # do not record commands starting with a space
setopt autocd                # forego the cd command and just specify the directory

bindkey -v                   # Enable VIM motion for the shell
bindkey -M viins 'jj' vi-cmd-mode  # Customize the command to enter normal mode


#-------------------------------------------------------------------------
# Exports and Aliases
#-------------------------------------------------------------------------
export EDITOR='nvim'
export VISUAL='nvim'

# Prioritize Homebrew Python
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Add uv tools to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add libpq (PostgreSQL client) to PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# fnm (Node.js version manager) — auto-switch on cd into a dir with .nvmrc/.node-version
eval "$(fnm env --use-on-cd --shell zsh)"

# EZA color theme
export EZA_COLORS="\
di=38;5;67:\
ex=38;5;9:\
fi=38;5;255:\
ln=38;5;250:\
ur=38;5;250:\
uw=38;5;250:\
ux=38;5;250:\
gr=38;5;250:\
gw=38;5;250:\
gx=38;5;250:\
tr=38;5;250:\
tw=38;5;250:\
tx=38;5;250:\
da=38;5;250:\
uu=38;5;255:\
gu=38;5;255:\
un=38;5;255:\
gn=38;5;255"

alias v=$EDITOR

alias python=python3
alias py=python3
alias pva='source .venv/bin/activate'
alias dstart='colima start'
alias dstop='colima stop'

alias ..='cd ..'
alias ws='cd ~/workspace'
alias dot='cd ~/.dotfiles'

alias l='eza -lA --group-directories-first --color=always'
alias cheat='nvim "+/## Cheatsheet" ~/.dotfiles/README.md'
alias ld='eza -lD --group-directories-first --color=always'
alias lf='eza -lf --group-directories-first --color=always'

# Create directory and change into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Machine-specific overrides (gitignored)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


#-------------------------------------------------------------------------
# Custom Prompt Configuration
#-------------------------------------------------------------------------

# Enable prompt substitution
setopt PROMPT_SUBST

# Color definitions
autoload -U colors && colors

# Git branch function — shows "bare" at worktree layout roots
git_branch() {
    if [[ "$(git rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then
        echo "bare"
        return
    fi
    git branch 2>/dev/null | sed -n 's/^\* //p'
}

# Git status indicators
git_status() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # No status indicators for bare repos
        [[ "$(git rev-parse --is-bare-repository 2>/dev/null)" == "true" ]] && return

        local git_info=""

        # Check for uncommitted changes
        if [[ -n $(git status -s 2>/dev/null) ]]; then
            git_info+="%{$fg[yellow]%}*"
        fi
        
        # Check for unpushed commits
        local ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
        if [[ $ahead -gt 0 ]]; then
            git_info+="%{$fg[green]%}↑$ahead"
        fi
        
        # Check for unpulled commits
        local behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
        if [[ $behind -gt 0 ]]; then
            git_info+="%{$fg[red]%}↓$behind"
        fi
        
        # Check for stashed changes
        if git rev-parse --verify refs/stash >/dev/null 2>&1; then
            git_info+="%{$fg[blue]%}≡"
        fi
        
        echo $git_info
    fi
}

PROMPT='%{$fg[cyan]%}%n%{$reset_color%} in %{$fg[blue]%}%~%{$reset_color%}'
PROMPT+='$(if [[ -n $(git_branch) ]]; then echo " on %{$fg[magenta]%}$(git_branch)%{$reset_color%}$(git_status)%{$reset_color%}"; fi)'
PROMPT+=$'\n''%F{250}❯%f '

# Add newline after each command for better separation
precmd() {
    print
}

# Disable color queries in VS Code terminal to prevent escape sequences
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    unset COLORTERM
    export TERM="xterm-256color"
    # Disable zsh syntax highlighting which may send color queries
    skip_global_compinit=1
fi

# Only load these plugins outside VS Code terminal
if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# FZF configuration
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Tmux helper functions
[[ -f ~/.tmux-functions.sh ]] && source ~/.tmux-functions.sh


