if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. ~/powerlevel10k/powerlevel10k.zsh-theme
. ~/.zsh_profile.zsh
. ~/.zsh_alias.zsh
. "$HOME/.cargo/env"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
