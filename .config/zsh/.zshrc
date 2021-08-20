# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
#setopt menu_complete # for better auto complete
case $TERM in
  st-256color|alacritty)
      precmd () {printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"}
    ;;
esac
# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
#bindkey -v
#bindkey -r "^["
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'ra\n'

bindkey -s '^a' 'R -q\n'

bindkey -s '^g' 'cd "$(dirname "$(fzf)")" && ls \n'

bindkey -s '^f' 'file=$(fzf) && [ $file ] && vim $file\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# View manpage with neovim
export MANPAGER="nvim -c 'set ft=man' -"

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh 2>/dev/null

source /usr/share/fzf/key-bindings.zsh 2>/dev/null
source /usr/share/fzf/completion.zsh 2>/dev/null

source ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins/zsh-history-substring-search.zsh 2>/dev/null
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true

export FZF_DEFAULT_OPTS="--layout=reverse --height 20%"
export FZF_DEFAULT_COMMAND="fd -a -H -E '*\.git' -E '*\.gitignore' -t f . ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER='``'
export FZF_COMPLETION_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -400'"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# shell
if [[ $UID -eq 0 ]]; then
    user_symbol="%F{8}%K{8}%F{1} %{%k%}%F{8}%f"
else
    user_symbol="%F{8}%K{8}%F{5} %{%k%}%F{8}%f"
fi

# Configuration
num_dirs=0 # Use 0 for full path
NEWLINE=$'\n'
#truncated_path="%F{8}%K{8}%F{4} %K{0} %F{white}%$num_dirs~%{%k%}%F{0}%f%F{13}❯%F{5}❯%F{14}❯%{%k%}%F{white}"
truncated_path=" %F{14}%$num_dirs~ %{%k%}%f%F{13}❯%{%k%}%F{white}"
background_jobs="%(1j.%F{0}%K{0}%F{3}%{%k%}%F{0}%f.)"
non_zero_return_value="%(0?..%F{0}%K{0}%F{1}%{%k%}%F{0}%f)"

# Left part of prompt
#PROMPT="$truncated_path $user_symbol "
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"'
PROMPT="$truncated_path "
# Right part of prompt
RPROMPT=" $background_jobs $non_zero_return_value"
# Input in bold
zle_highlight=(default:bold)

# cd ls
cl() {
  cd "$@" && ls;
}
