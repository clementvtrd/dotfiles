if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh_profile.zsh
source $HOME/.zsh_alias.zsh
source $HOME/.cargo/env

if [ -d /etc/profile.d ]; then
  for profile in /etc/profile.d/*.sh; do
    if [ -r $profile ]; then
      . $profile
    fi
  done
  unset profile
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
