# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Environment
export EDITOR='nvim'
export VISUAL='nvim'

# Quickly jump around directories.
alias ..='cd ..'
alias ws='cd ~/workspace'

# List directory contents.
alias l='ls -lAh'
alias ll='ls -lh'

# Python
alias activate='source ./venv/bin/activate'

# NVim
alias vi='nvim'
alias v='nvim'

HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=100

setopt APPEND_HISTORY        # keep history
setopt INC_APPEND_HISTORY    # update the history after execution (not end of session)
setopt SHARE_HISTORY         # share history between sessions if we have multiple going
setopt EXTENDED_HISTORY      # add timestamps to history
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS    # remove extra blank space
setopt HIST_FIND_NO_DUPS     # do not find duplicates when searching
setopt HIST_IGNORE_SPACE     # do not record commands starting with a space

# https://wiki.archlinux.org/title/Zsh#Key_bindings
# Create a zkbd compatible hash
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Shift-Left]="${terminfo[kLFT5]}"
key[Shift-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
[[ -n "${key[Shift-Left]}" ]] && bindkey -- "${key[Shift-Left]}" backward-word
[[ -n "${key[Shift-Right]}" ]] && bindkey -- "${key[Shift-Right]}" forward-word
bindkey '^[[1;5D' backward-word         # ctrl + left arrow
bindkey '^[[1;5C' forward-word          # ctrl + right arrow

# Setup ZPlug
# $ curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
#source ~/.zplug/init.zsh

#zplug 'zplug/zplug', hook-build:'zplug --self-manage'
#zplug 'zsh-users/zsh-autosuggestions'

#if ! zplug check; then
#	zplug install
#fi

#if zplug check "zsh-users/zsh-autosuggestions"; then
#	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=238'
#fi

#zplug load

#plugins=(
	#zsh-syntax-highlighting
	#zsh-completions
	#zsh-autosuggestions
#)

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# if tmux is executable, X is running, and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ]; then
  [ -z "${TMUX}" ] && { tmux attach || tmux; } >/dev/null 2>&1
fi

