bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

setopt NO_BEEP BASH_AUTO_LIST

autoload -U compinit 
compinit
zmodload -i zsh/complist

zstyle ':completion:*' special-dirs true

