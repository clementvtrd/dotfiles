export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
