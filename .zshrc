PS1='%m %1~ %# '

bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

setopt NO_BEEP BASH_AUTO_LIST

DISABLE_AUTO_TITLE="true"

autoload -U compinit 
compinit
zmodload -i zsh/complist

zstyle ':completion:*' special-dirs true

ZSH_EXTRAS="${HOME}/.zshrc-extras"
[ -f "$ZSH_EXTRAS" ] && source ${ZSH_EXTRAS}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
